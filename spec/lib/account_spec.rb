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
        let(:last_candle) { double('candlestick') }
        let(:last_data) do
          {
            :candlestick => last_candle
          }
        end
        let(:chart) { double('chart', pair: pair, last: last_data) }

        before do
          positions.stub(:delete_if).and_yield(open_position).and_return([open_position])
        end

        context 'different pair' do
          let(:open_position_pair) { double('gbpjpy') }
          
          before do
            allow(open_position).to receive(:close_if_hit!).and_return(false)
          end

          it 'does nothing' do
            expect(open_position).to_not have_received(:close_if_hit!)
          end
        end

        context 'nothing hit' do
          before do
            allow(open_position).to receive(:close_if_hit!).and_return(false)
            allow(open_position).to receive(:update_trail_stop)
            subject.manage_positions(chart)
          end

          it 'selects the position that matches the pair' do
            expect(positions).to have_received(:delete_if)
          end

          it 'updates the trail stop' do
            expect(open_position).to have_received(:update_trail_stop)
          end

          it 'does not put the position to history' do
            expect(history).to_not receive(:<<)
          end
        end

        context 'position closed' do
          before do
            allow(open_position).to receive(:close_if_hit!).with(last_data).and_return(true)
            subject.manage_positions(chart)
          end

          it 'calls the function to close' do
            expect(open_position).to have_received(:close_if_hit!).with(last_data)
          end

          it 'position is archived' do
            expect(history.first).to be(open_position)
          end
        end
      end

      describe 'open orders' do
      end
    end
  end
end
