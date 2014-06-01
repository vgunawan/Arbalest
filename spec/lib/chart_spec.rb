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
            list << { 
              timestamp: (first_of_jan + 3600 * i).to_i,
              o: 170 + i, 
              h: 160 + i, 
              l: 180 + i, 
              c: 175 + i }
          end
          list
        end

        it("has first element") do 
          first_key = first_of_jan.to_i
          p "first key #{first_key}"
          expect(subject.candles[first_key]).to eq(Candlestick.new(o: 170, h: 160, l: 180, c: 175))
        end
      end
      
      context "with volumes" do
        let(:list) do
          list = []
          for i in 0..5 do
            list << {
              timestamp: (first_of_jan + 3600 * i).to_i, 
              o: 170 + i, 
              h: 160 + i, 
              l: 180 + i,
              c: 175 + i, 
              v: 300 + i }
          end
          list
        end

        it("has first element") do 
          first_key = first_of_jan.to_i
          expect(subject.candles[first_key]).to eq(Candlestick.new(o: 170, h: 160, l: 180, c: 175, v: 300))
        end
      end

    end
  end
end
