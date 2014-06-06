require 'spec_helper'
require 'time'

module Arbalest
  describe Chart do

    let(:first_of_jan) { Time.parse('2014-01-01T00:00:00') }
    subject { Chart.new(list) }

    context "with no volumes" do
      let(:list) do
        list = []
        for i in 0..5 do
          list << { 
            timestamp: (first_of_jan + 3600 * i).to_i,
            o: 170 + i, 
            h: 190 + i, 
            l: 160 + i, 
            c: 175 + i }
        end
        list
      end

      it("first element has timestamp") do 
        expect(subject.data.first[:timestamp]).to eq(list.first[:timestamp])
      end

      it("first element has a candle") do 
        expect(subject.data.first[:candle]).
          to eq(Candlestick.new(o: 170, h: 190, l: 160, c: 175))
      end
    end

    let(:list) do
      list = []
      for i in 0..5 do
        list << {
          timestamp: (first_of_jan + 3600 * i).to_i, 
          o: 170 + i, 
          h: 190 + i, 
          l: 160 + i,
          c: 175 + i, 
          v: 300 + i }
      end
      list
    end

    it("first element has timestamp") do 
      expect(subject.data.first[:timestamp]).to eq(list.first[:timestamp])
    end

    it("first element has a candle") do 
      expect(subject.data.first[:candle]).
        to eq(Candlestick.new(o: 170, h: 190, l: 160, c: 175, v: 300))
    end

    describe "#at" do
      
      it "returns closest previous candle" do
        expect(subject.at(first_of_jan + 3599)).
          to eq(Candlestick.new(o: 170, h: 190, l: 160, c: 175, v: 300))
      end
      
      context "exact time" do
        it "returns the candle" do
          expect(subject.at(first_of_jan + 3600 * 5)).
            to eq(Candlestick.new(o: 175, h: 195, l: 165, c: 180, v: 305))
        end
      end

      context "far in the future" do
        it "returns the most recent candle" do
          expect(subject.at(Time.parse("2015-01-01T00:01:00"))).
            to eq(Candlestick.new(o: 175, h: 195, l: 165, c: 180, v: 305))
        end
      end

      context "no earlier data" do
        it "returns nil" do
          expect(subject.at(first_of_jan - 1)).
            to be_nil
        end
      end

      context "with no data" do
        let(:list) { [] }
        it "returns nil" do
          expect(subject.at(first_of_jan)).to be_nil
        end
      end

    end

    describe "#range" do
      
      it "returns candles including the boundary" do
        expected = [
          { timestamp: first_of_jan.to_i, candle: Candlestick.new(o: 170, h: 190, l: 160, c: 175, v: 300) },
          { timestamp: (first_of_jan + 3600).to_i, candle: Candlestick.new(o: 171, h: 191, l: 161, c: 176, v: 301) }
        ]
        expect(subject.range(first_of_jan, first_of_jan + 3600)).to eq(expected)
      end 
    end

  end
end
