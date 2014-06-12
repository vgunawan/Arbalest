require 'spec_helper'

module Arbalest
  describe Account do
    let(:balance) { 100 }

    subject { Account.new(balance) }

    it('balance') { expect(subject.balance).to eq(balance) }
    it('positions') { expect(subject.positions).to eq([]) }
    it('working_orders') { expect(subject.working_orders).to eq([]) }

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
  end
end
