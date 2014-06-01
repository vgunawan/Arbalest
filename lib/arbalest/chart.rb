module Arbalest
  class Chart

    attr_reader :candles

    def initialize(candles)
      @candles = candles
    end

    class << self
      def from_list(list)
        candles = {}
        list.each {|e| candles[e.first.to_i] = Candlestick.new(*e[1..4])}

        self.new(candles)
      end
    end
  end
end
