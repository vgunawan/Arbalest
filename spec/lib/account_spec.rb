require 'spec_helper'

module Arbalest
  describe Account do
    let(:balance) { 100 }

    subject { Account.new(balance) }

    it('balance') { expect(subject.balance).to eq(balance) }
    it('positions') { expect(subject.positions).to be_empty }
    it('working_orders') { expect(subject.working_orders).to be_empty }
    it('history') { expect(subject.history).to be_empty }

    describe '#open' do
      let(:order) { double('order') }

      before do
        subject.working_orders.stub(:<<).with(order)
        subject.open(order)
      end

      it 'puts into working order list' do
        expect(subject.working_orders).to have_received(:<<).with(order)
      end
    end

    describe '#manage_positions' do
      describe 'existings' do
        let(:pair) { double('audjpy') }
        let(:history) { subject.history }
        let(:positions) { subject.positions }
        let(:open_position_pair) { pair }
        let(:open_position) { double('open position', pair: open_position_pair) }
        let(:closing_price) { double('100') }
        let(:last_data) do
          {
            :candlestick => double('candlestick')
          }
        end
        let(:chart) { double('chart', pair: pair, last: last_data) }

        before do
          positions.stub(:delete_if).and_yield(open_position).and_return([open_position])
        end

        context 'different pair' do
          let(:open_position_pair) { double('gbpjpy') }

          before do
            allow(open_position).to receive(:limit_hit?).and_return(false)
          end

          it 'does nothing' do
            expect(open_position).to_not have_received(:limit_hit?)
          end
        end

        context 'nothing hit' do
          before do
            allow(open_position).to receive(:limit_hit?).and_return(false)
            allow(open_position).to receive(:stop_hit?).and_return(false)
            subject.manage_positions(chart)
          end

          it 'selects the position that matches the pair' do
            expect(positions).to have_received(:delete_if)
          end
        end

        context 'limit hit' do
          before do
            allow(open_position).to receive(:limit_hit?).and_return(true)
            allow(open_position).to receive(:close).with(:limit_hit, closing_price)
            allow(open_position).to receive(:limit).and_return(closing_price)
            subject.manage_positions(chart)
          end

          it 'close the position' do
            expect(open_position).to have_received(:close).with(:limit_hit, closing_price)
          end

          it 'moves the position to history' do
            expect(history.first).to be(open_position)
          end
        end

        context 'stop hit' do
          before do
            allow(open_position).to receive(:limit_hit?).and_return(false)
            allow(open_position).to receive(:stop_hit?).and_return(true)
            allow(open_position).to receive(:close).with(:stop_hit, closing_price)
            allow(open_position).to receive(:stop).and_return(closing_price)
            subject.manage_positions(chart)
          end

          it 'close the position' do
            expect(open_position).to have_received(:close).with(:stop_hit, closing_price)
          end

          it 'moves the position to history' do
            expect(history.first).to be(open_position)
          end
        end
      end

      describe 'open orders' do
      end
    end
  end
end
