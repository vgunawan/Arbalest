require 'spec_helper'
require 'time'

module Arbalest
  describe Chart do
    let(:candles) { [] }

    subject { Chart.new(candles) } 
    
    it("has #candles") { expect(subject.candles).to eq(candles) }
    
    describe "#from_list" do
      
      let(:first_of_jan) { Time.parse('2014-01-01T00:00:00') }
      subject { Chart.from_list(list) }
      
      context "with no volumes" do
        let(:list) do
          list = []
          for i in 0..5 do
            list << [first_of_jan + 3600 * i, 170 + i, 160 + i , 180 + i, 175 + i]
          end
          list
        end

        it("has first element") do 
          first_key = first_of_jan.to_i
          expect(subject.candles[first_key]).to eq(Candlestick.new(170, 160, 180, 175))
        end
      end
      
      context "with volumes" do
        let(:list) do
          list = []
          for i in 0..5 do
            list << [first_of_jan + 3600 * i, 170 + i, 160 + i , 180 + i, 175 + i, 300 + i]
          end
          list
        end

        it("has first element") do 
          first_key = first_of_jan.to_i
          expect(subject.candles[first_key]).to eq(Candlestick.new(170, 160, 180, 175, v: 300))
        end
      end

    end
  end
end
