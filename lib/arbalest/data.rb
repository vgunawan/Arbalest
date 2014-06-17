module Arbalest
  class Data
    attr_reader :timestamp, :candlestick

    def initialize(timestamp, candlestick)
      @timestamp = timestamp
      @candlestick = candlestick
    end
    
    def hit?(target)
      target >= candlestick.low and target <= candlestick.high
    end

    def ==(other)
      timestamp == other.timestamp and
      candlestick == other.candlestick
    end
  end
end
