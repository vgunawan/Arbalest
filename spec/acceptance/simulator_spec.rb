require 'spec_helper'

module Arbalest
  describe Simulator do
    describe "#start" do
      
      context "with no chart data" do
        
        let(:balance) { 1000 }
        let(:account) { Account.new(balance) }
        let(:data) { [] }
        let(:pilot) { Pilots::Test }
        subject { Simulator.new(account, data, pilot) }
        
        before { subject.start }

        it "account balance remains the same" do
          expect(account.balance).to eq(balance)
        end
      end

      context "with enough data to start" do
        let(:data) { [
          [Time.parse('2014-05-30T09:30:00'),170.19900,170.22200,170.05600,170.06200,920],
          [Time.parse('2014-05-30T09:45:00'),170.06100,170.09400,170.02200,170.08600,947],
          [Time.parse('2014-05-30T10:00:00'),170.08800,170.11500,169.99200,170.01600,1109],
          [Time.parse('2014-05-30T10:15:00'),170.01500,170.09500,169.98700,170.08300,784],
          [Time.parse('2014-05-30T10:30:00'),170.08500,170.09100,170.03000,170.04500,609],
          [Time.parse('2014-05-30T10:45:00'),170.04000,170.12100,170.00200,170.05500,813],
          [Time.parse('2014-05-30T11:00:00'),170.05300,170.20600,170.03700,170.14500,728],
          [Time.parse('2014-05-30T11:15:00'),170.14000,170.17200,170.04700,170.10100,708],
          [Time.parse('2014-05-30T11:30:00'),170.10600,170.13300,170.07700,170.10600,747],
          [Time.parse('2014-05-30T11:45:00'),170.10500,170.12300,170.05400,170.06100,586],
          [Time.parse('2014-05-30T12:00:00'),170.06200,170.20200,170.05100,170.17100,776],
          [Time.parse('2014-05-30T12:15:00'),170.16900,170.23600,170.15600,170.20300,591],
          [Time.parse('2014-05-30T12:30:00'),170.20700,170.22300,170.12900,170.18000,494],
          [Time.parse('2014-05-30T12:45:00'),170.18200,170.21100,170.10900,170.19900,694],
          [Time.parse('2014-05-30T13:00:00'),170.19600,170.24100,170.15500,170.16800,480]]
        }
        let(:balance) { 1000 }
        let(:account) { Account.new(balance) }
        let(:pilot) { Pilots::Test }
        subject { Simulator.new(account, data, pilot) }


      end
    end
  end
end
