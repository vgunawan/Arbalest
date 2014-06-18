require 'spec_helper'

module Arbalest
  describe Position do
    let(:pair) { double('eurchf', one_pip: one_pip) }
    let(:one_pip) { 0.0001 }
    let(:direction) { :long }
    let(:opening_price) { 1.23425 }
    let(:time) { Time.parse("2014-01-01T00:01:45") }
    let(:order) { double('order', stop: nil, limit: nil) }

    subject { Position.new(pair, direction, opening_price, time, order) }

    it("pair") { expect(subject.pair).to eq(pair) }
    it("direction") { expect(subject.direction).to eq(direction) }
    it("opening_price") { expect(subject.opening_price).to eq(opening_price) }
    it("time") { expect(subject.time).to eq(time) }
    it("status") { expect(subject.status).to eq(:open) }
    it('order') { expect(subject.order).to eq(order) }

    describe "#close" do
      let(:status) { :test_status }
      let(:closing_price) { 1.00 }

      before do
        subject.close(status, closing_price)
      end

      it "sets status to close" do
        expect(subject.status).to eq(status)  
      end

      it "sets the closing price" do
        expect(subject.closing_price).to eq(closing_price)
      end
    end

    describe '#close_if_hit!' do
      let(:data) { double('data') } 
      let(:chart) { double('chart', last: [data]) }

      context 'limit hit' do
        let(:limit) { 30 }
        let(:expected_limit) { opening_price + one_pip * limit }
        let(:direction) { :long }
        let(:one_pip) { 0.0001 }

        before do
          allow(data).to receive(:hit?).with(expected_limit).and_return(true)
          allow(order).to receive(:limit).and_return(limit)
          subject.stub(:close)
          subject.close_if_hit!(chart)
        end

        it 'close the position' do
          expect(subject).to have_received(:close).with(:limit_hit, expected_limit)
        end
      end

      context 'stop hit' do
        let(:stop) { 10 }
        let(:limit) { double('limit') }
        let(:expected_stop) { opening_price + one_pip * stop }
        let(:direction) { :short }
        let(:one_pip) { 0.0001 }

        before do
          allow(data).to receive(:hit?).with(limit).and_return(false)
          allow(data).to receive(:hit?).with(expected_stop).and_return(true)
          allow(order).to receive(:stop).and_return(stop)
          subject.stub(:limit_price).and_return(limit)
          subject.stub(:close)
          subject.close_if_hit!(chart)
        end

        it 'close the position' do
          expect(subject).to have_received(:close).with(:stop_hit, expected_stop)
        end
      end

      context 'time limit hit' do
        let(:stop) { double('stop') }
        let(:limit) { double('limit') }
        let(:closing_price) { double('closing price') }
        let(:candlestick) { double('candlestick', c: closing_price) }
        let(:time_limit) { 3600 * 3 }
        let(:position_time_limit) { time + time_limit }

        before do
          allow(data).to receive(:hit?).with(limit).and_return(false)
          allow(data).to receive(:hit?).with(stop).and_return(false)
          allow(chart).to receive(:elapsed?).
            with(position_time_limit).and_return(true)
          allow(data).to receive(:close).and_return(closing_price)
          allow(order).to receive(:time_limit).and_return(time_limit)
          subject.stub(:limit_price).and_return(limit)
          subject.stub(:stop_price).and_return(stop)
          subject.stub(:close)
          subject.close_if_hit!(chart)
        end

        it 'close the position' do
          expect(subject).to have_received(:close).with(:time_limit, closing_price)
        end
      end
    end
    
    describe 'stop level' do
      context 'with no stop set' do
        before do
          allow(order).to receive(:stop).and_return(nil)
        end

        it 'returns nil' do
          expect(subject.stop_price).to be_nil
        end
      end

      context 'with a long position' do
        let(:stop) { 10 }
        let(:stop_price) { opening_price - one_pip * stop }
        let(:direction) { :long }

        before do
          allow(subject).to receive(:direction).and_return(direction)
          allow(order).to receive(:stop).and_return(stop)
        end

        it 'returns the stop level' do
          expect(subject.stop_price).to eq(stop_price)
        end
      end

      context 'with short position' do
        let(:stop) { 10 }
        let(:stop_price) { opening_price + one_pip * stop }
        let(:direction) { :short }

        before do
          allow(subject).to receive(:direction).and_return(direction)
          allow(order).to receive(:stop).and_return(stop)
        end

        it 'returns the stop level' do
          expect(subject.stop_price).to eq(stop_price)
        end
      end
    end

    describe 'limit level' do
      context 'with no limit set' do
        before do
          allow(order).to receive(:limit).and_return(nil)
        end

        it 'returns nil' do
          expect(subject.limit_price).to be_nil
        end
      end

      context 'with long position' do
        let(:limit) { 10 }
        let(:limit_price) { opening_price + one_pip * limit }
        let(:direction) { :long }
        
        before do
          allow(subject).to receive(:direction).and_return(direction)
          allow(order).to receive(:limit).and_return(limit)
        end

        it 'returns the stop level' do
          expect(subject.limit_price).to eq(limit_price)
        end
      end

      context 'with short position' do
        let(:limit) { 10 }
        let(:limit_price) { opening_price - one_pip * limit }
        let(:direction) { :short }
        
        before do
          allow(subject).to receive(:direction).and_return(direction)
          allow(order).to receive(:limit).and_return(limit)
        end
        it 'returns the stop level' do
          expect(subject.limit_price).to eq(limit_price)
        end
      end
    end

    describe '#update_trail_stop' do
      let(:data) { double('data') } 
      let(:chart) { double('chart', last: [data]) }
      let(:opening_price) { 1.00 }
      let(:stop_price) { opening_price - one_pip * stop }
      let(:direction) { :long }

      before do
        allow(subject).to receive(:direction).and_return(direction)
      end

      context 'with no trail specified' do
        let(:stop) { 10 }
        let(:order) { double('order', stop: 10, trail: nil) }

        it 'does not update stop' do
          subject.update_trail_stop(chart)
          expect(subject.stop_price).to eq(stop_price)
        end
      end

      context 'price moved more than the trail' do
        let(:trail) { 5 }
        let(:expected_price) { opening_price }
        let(:order) { double('order', one_pip: one_pip, trail: trail, stop: 5) }
        let(:high) { 1.00081 }
        let(:candle) { double('candle', high: high) }
        let(:data) { double('data', candlestick: candle) }

        it 'adjust the stop' do
          subject.update_trail_stop(chart)
          expect(subject.stop_price).to eq(expected_price)
        end
      end

      context 'price moved more than twice the trail' do
        let(:trail) { 5 }
        let(:expected_price) { opening_price + trail * one_pip }
        let(:order) { double('order', one_pip: one_pip, trail: trail, stop: 5) }
        let(:high) { 1.00101 }
        let(:candle) { double('candle', high: high) }
        let(:data) { double('data', candlestick: candle) }

        it 'adjust the stop' do
          subject.update_trail_stop(chart)
          expect(subject.stop_price).to eq(expected_price)
        end
      end
    end
  end
end
