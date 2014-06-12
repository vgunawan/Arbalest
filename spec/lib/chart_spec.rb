require 'spec_helper'
require 'time'

module Arbalest
  describe Chart do

    let(:first_of_jan) { Time.parse('2014-01-01T00:00:00') }
    let(:name) { 'aususd15m' }
    subject { Chart.new(list, name) }

    it("name") { expect(subject.name).to eq(name) }

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

    let(:first_candle) { Candlestick.new(o: 170, h: 190, l: 160, c: 175, v: 300)}
    let(:fifth_candle) { Candlestick.new(o: 174, h: 194, l: 164, c: 179, v: 304)}
    let(:last_candle) { Candlestick.new(o: 175, h: 195, l: 165, c: 180, v: 305)}
    let(:fifth_candle_timestamp) { first_of_jan + 3600 * 4 }
    let(:last_candle_timestamp) { first_of_jan + 3600 * 5 }

    it("first element has timestamp") do 
      expect(subject.data.first[:timestamp]).to eq(list.first[:timestamp])
    end

    it("first element has a candle") do 
      expect(subject.data.first[:candle]).to eq(first_candle)
    end

    describe "#at" do
      
      it "returns closest previous candle" do
        expect(subject.at(first_of_jan + 3599)).to eq(first_candle)
      end
      
      context "exact time" do
        it "returns the candle" do
          expect(subject.at(first_of_jan + 3600 * 5)).to eq(last_candle)
        end
      end

      context "far in the future" do
        it "returns the most recent candle" do
          expect(subject.at(Time.parse("2015-01-01T00:01:00"))).to eq(last_candle)
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
          { timestamp: first_of_jan.to_i, candle: first_candle },
          { 
            timestamp: (first_of_jan + 3600).to_i, 
            candle: Candlestick.new(o: 171, h: 191, l: 161, c: 176, v: 301) }
        ]
        expect(subject.range(first_of_jan, first_of_jan + 3600)).to eq(expected)
      end

      context "with unbounded beginning" do
        let(:unbounded_start) { first_of_jan - 3600 }
        let(:expected) {
          [ {timestamp: first_of_jan.to_i, candle: first_candle} ]
        }

        it "returns a new chart from start" do
          expect(subject.range(unbounded_start, first_of_jan + 1)).to eq(expected)
        end
      end

      context "with unbounded end" do
        let(:unbounded_end) { Time.parse("2015-01-01T00:01:00") }
        let(:expected) {
          [ {timestamp: (first_of_jan + 3600 * 5).to_i, candle: last_candle} ]
        }

        it "returns a new chart to end" do
          expect(subject.range(first_of_jan + 3600 * 5, unbounded_end)).
            to eq(expected)
        end
      end
    end

    describe "#last" do
      it "returns the last data" do
        expect(subject.last).to eq(
          [{ timestamp: last_candle_timestamp.to_i, candle: last_candle}])
      end

      context "with a given time" do
        let(:hour) { 3600 }

        it "returns the candles asked" do
          expect(subject.last(hour)).to eq(
            [{ timestamp: fifth_candle_timestamp.to_i, candle: fifth_candle}, 
             { timestamp: last_candle_timestamp.to_i, candle: last_candle}])
        end
      end
    end

    describe "#replay" do
      context 'with no block given' do
        it 'raises error' do
          expect{subject.replay}.to raise_error
        end
      end

      context 'block is given' do
        before do
          subject.data.stub(:each)
        end

        it 'does not raise error' do
          expect{subject.replay{ }}.to_not raise_error 
        end

        it 'iterates through the data and pass it to the block' do
          expect(subject.data).to have_received(:each)
        end
      end
    end
  end
end
