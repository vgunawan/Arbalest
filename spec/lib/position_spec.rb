require 'spec_helper'

module Arbalest
  describe Position do
    let(:pair) { double('eurchf') }
    let(:direction) { :long }
    let(:opening_price) { 1.23425 }
    let(:time) { Time.parse("2014-01-01T00:01:45") }
    let(:order) { double('order') }

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

      context 'limit hit' do
        let(:limit) { 30 }
        let(:expected_limit) { opening_price + one_pip * limit }
        let(:direction) { :long }
        let(:one_pip) { 0.0001 }

        before do
          allow(data).to receive(:hit?).with(expected_limit).and_return(true)
          allow(order).to receive(:limit).and_return(limit)
          allow(pair).to receive(:one_pip).and_return(one_pip)
          subject.stub(:close)
          subject.close_if_hit!(data)
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
          allow(pair).to receive(:one_pip).and_return(one_pip)
          subject.stub(:limit).and_return(limit)
          subject.stub(:close)
          subject.close_if_hit!(data)
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
          allow(data).to receive(:closed_after?).
            with(position_time_limit).and_return(true)
          allow(data).to receive(:close).and_return(closing_price)
          allow(order).to receive(:time_limit).and_return(time_limit)
          subject.stub(:limit).and_return(limit)
          subject.stub(:stop).and_return(stop)
          subject.stub(:close)
          subject.close_if_hit!(data)
        end

        it 'close the position' do
          expect(subject).to have_received(:close).with(:time_limit, closing_price)
        end
      end
    end
  end
end
