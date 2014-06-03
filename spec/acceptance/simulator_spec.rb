require 'spec_helper'

module Arbalest
  describe Simulator do
    describe "#start" do
      context "with no chart data" do
        let(:chart_data) { [] }
        let(:balance) { 1000 }
        let(:account) { Account.new(balance) }
        let(:data) { [] }
        let(:pilot) { Pilots::MomentumTrader }
        subject { Simulator.new(account, data, pilot) }
        
        before { subject.start }

        it "account balance remains the same" do
          expect(account.balance).to eq(balance)
        end
      end

    end
  end
end
