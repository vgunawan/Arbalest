module Arbalest
  class Chart

    attr_reader :candles

    def initialize(candles)
      @candles = candles
    end

    def at(time)
      i = candles.find_index { |c| c[:timestamp] > time.to_i }
      return nil if i < 1
      candles[i-1][:candle]
    end

    class << self
      def from_list(list)
        candles = []
        list.each do |e| 
          params = e.select { |k,v| [:o, :h, :l, :c, :v].include? k }
          candles << { timestamp: e[:timestamp], candle: Candlestick.new(params) }
        end

        self.new(candles)
      end
    end
  end
end
