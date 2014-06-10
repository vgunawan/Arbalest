require 'spec_helper'
Candlestick = Arbalest::Candlestick

module Arbalest::Indicators
  describe MomentumA do
    subject { MomentumA }

    let(:signal_pips) { 10 }

    def timestamp(seed)
      Time.parse("2014-01-01T:13:00:00").to_i + seed * 3600
    end

    before do
      @order = subject.calculate(data, signal_pips)
    end

    context "not enough momentum" do
      let(:data) do
        [
          { timestamp: timestamp(0), candlestick: Candlestick.new(o: 10, h: 20, l: 9, c: 12)},
          { timestamp: timestamp(11), candlestick: Candlestick.new(o: 12, h: 20, l: 9, c: 12)},
          { timestamp: timestamp(23), candlestick: Candlestick.new(o: 10, h: 20, l: 5, c: 8)},
        ]
      end

      it "does not return any order" do
        expect(@order).to be(nil)
      end
    end

    context "with enough momentum to go long" do
      let(:closing_price) { 23 }
      let(:data) do
        [
          { timestamp: timestamp(0), candlestick: Candlestick.new(o: 10, h: 20, l: 9, c: 12)},
          { timestamp: timestamp(11), candlestick: Candlestick.new(o: 12, h: 20, l: 9, c: 12)},
          { timestamp: timestamp(23), 
            candlestick: Candlestick.new(o: 15, h: 25, l: 10, c: closing_price)},
        ]
      end

      it "returns a long order" do
        expect(@order).to eq({ long: closing_price })
      end

    end
  end
end
