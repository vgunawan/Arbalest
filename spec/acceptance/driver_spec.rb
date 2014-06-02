require 'spec_helper'

module Arbalest
  describe Driver do
    describe "#drive" do
      context "with no chart data" do
        let(:chart_data) { [] }
        let(:balance) { 1000 }
        let(:account) { Account.new(balance) }
        subject { instance_double(Driver.new(account)) }
        
        before { subject.drive }
        it "does not run" do
          expect(subject).to not_received(:run)
        end

        it "account balance remains the same" do
          expect(account.balance).to eq(10000)
        end
      end

    end
  end
end
