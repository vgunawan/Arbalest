require 'spec_helper'

module Arbalest
  describe Simulator do
    describe "#start" do
      
      context "with no chart data" do
        let(:balance) { 1000 }  
        let(:account) { Account.new(balance) }
        let(:data) { [] }
        let(:pilot) { Pilots::Sagara }
        subject { Simulator.new(account, pilot) }
        
        before do
          subject.load('spec/fixtures/empty.csv', :gbpjpy)
          subject.play
        end

        it "account balance remains the same" do
          expect(account.balance).to eq(balance)
        end
      end

      context "with enough data to start" do
        let(:balance) { 1000 }
        let(:account) { Account.new(balance) }
        let(:pilot) { Pilots::Sagara }

        subject { Simulator.new(account, pilot) }
      end
    end
  end
end
