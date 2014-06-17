require 'spec_helper'
require 'time'

module Arbalest
  describe Chart do

    let(:first_of_jan) { Time.parse('2014-01-01T00:00:00') }
    let(:name) { :audusd }
    let(:interval) { 3600 }
    subject { Chart.new(list, name, interval) }

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
        expect(subject.data.first.timestamp).to eq(list.first[:timestamp])
      end

      it("first element has a candle") do 
        expect(subject.data.first.candlestick).
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
      expect(subject.data.first.timestamp).to eq(list.first[:timestamp])
    end

    it("first element has a candle") do 
      expect(subject.data.first.candlestick).to eq(first_candle)
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
          Data.new(first_of_jan.to_i, first_candle),
          Data.new(first_of_jan.to_i + 3600, 
                   Candlestick.new(o: 171, h: 191, l: 161, c: 176, v: 301))
        ]
        expect(subject.range(first_of_jan, first_of_jan + 3600)).to eq(expected)
      end

      context "with unbounded beginning" do
        let(:unbounded_start) { first_of_jan - 3600 }
        let(:expected) {
          [ Data.new(first_of_jan.to_i, first_candle) ]
        }

        it "returns a new chart from start" do
          expect(subject.range(unbounded_start, first_of_jan + 1)).to eq(expected)
        end
      end

      context "with unbounded end" do
        let(:unbounded_end) { Time.parse("2015-01-01T00:01:00") }
        let(:expected) {
          [ Data.new((first_of_jan + 3600 * 5).to_i, last_candle) ]
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
          [Data.new(last_candle_timestamp.to_i, last_candle)])
      end

      context "with a given time" do
        let(:hour) { 3600 }

        it "returns the candles asked" do
          expect(subject.last(hour)).to eq(
            [ Data.new(fifth_candle_timestamp.to_i, fifth_candle), 
              Data.new(last_candle_timestamp.to_i, last_candle)])
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
        let(:new_chart) { double('new chart') }
        let(:single_data) { double('single data') }

        before do
          allow(new_chart).to receive(:<<)
          subject.data.stub(:each).and_yield(single_data)
          Chart.stub(:new).and_return(new_chart)
        end

        it 'does not raise error' do
          expect{subject.replay{ }}.to_not raise_error 
        end

        it 'appends new_chart with each data' do
          subject.replay {}
          expect(new_chart).to have_received(:<<).with(single_data)
        end

        it 'yield every data to the given block' do
          expect { |b| subject.replay(&b) }.to yield_with_args
        end
      end
    end

    describe '#<<' do
      let (:another_chart) { double('another chart') }
      let (:another_data) { double('another data') }
      let (:data) { subject.data }

      before do
        allow(data).to receive(:<<)
        another_chart.stub(:instance_of?).with(Chart).and_return(true)
        another_chart.stub(:data).and_return(another_data)
      end

      it 'appends the internal data' do 
        subject << another_chart
        expect(data).to have_received(:<<).with(another_data)
      end

      context 'with an array of data' do
        let (:another_data) { double('an array') }

        before do
          another_data.stub(:instance_of?).with(Chart).and_return(false)
          another_data.stub(:instance_of?).with(Array).and_return(true)
          subject << another_data
        end

        it 'appends the internal data' do
          expect(data).to have_received(:<<).with(another_data)
        end
      end

      context 'with unsupported data' do 
        let (:another_data) { double('unsupported type') }

        before do
          another_data.stub(:instance_of?).with(Chart).and_return(false)
          another_data.stub(:instance_of?).with(Array).and_return(false)
        end

        it 'appends with empty array' do
          subject << another_data
          expect(data).to have_received(:<<).with([])
        end
      end
    end

    describe '#elapsed?' do
      context 'in the future' do
        let(:future) { Time.parse('2014-01-01T07:00') }

        it 'returns false' do
          expect(subject.elapsed?(future)).to be_false
        end
      end

      context 'in the past' do
        let(:past) { Time.parse('2014-01-01T06:59') }

        it 'return true' do
          expect(subject.elapsed?(past)).to be_false
        end
      end
    end
  end
end
