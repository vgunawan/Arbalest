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
        
        before { subject.play }

        it "account balance remains the same" do
          expect(account.balance).to eq(balance)
        end
      end

      context "with enough data to start" do
        let(:data) { [
          [Time.parse('2014-05-30T09:30:'),170.199,170.222,170.056,170.062,920],
          [Time.parse('2014-05-30T09:45:'),170.061,170.094,170.022,170.086,947],
          [Time.parse('2014-05-30T10::'),170.088,170.115,169.992,170.016,1109],
          [Time.parse('2014-05-30T10:15:'),170.015,170.095,169.987,170.083,784],
          [Time.parse('2014-05-30T10:30:'),170.085,170.091,170.030,170.045,609],
          [Time.parse('2014-05-30T10:45:'),170.040,170.121,170.2,170.055,813],
          [Time.parse('2014-05-30T11::'),170.053,170.206,170.037,170.145,728],
          [Time.parse('2014-05-30T11:15:'),170.140,170.172,170.047,170.101,708],
          [Time.parse('2014-05-30T11:30:'),170.106,170.133,170.077,170.106,747],
          [Time.parse('2014-05-30T11:45:'),170.105,170.123,170.054,170.061,586],
          [Time.parse('2014-05-30T12::'),170.062,170.202,170.051,170.171,776],
          [Time.parse('2014-05-30T12:15:'),170.169,170.236,170.156,170.203,591],
          [Time.parse('2014-05-30T12:30:'),170.207,170.223,170.129,170.180,494],
          [Time.parse('2014-05-30T12:45:'),170.182,170.211,170.109,170.199,694],
          [Time.parse('2014-05-30T13::'),170.196,170.241,170.155,170.168,480]]
        }
        let(:balance) { 1000 }
        let(:account) { Account.new(balance) }
        let(:pilot) { Pilots::Test }

        subject { Simulator.new(account, pilot) }
      end
    end
  end
end
