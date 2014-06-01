module Arbalest
  class Chart

    attr_reader :candles

    def initialize(candles)
      @candles = candles
    end

    class << self
      def from_list(list)
        candles = {}
        list.each do |e| 
          candles[e.first.to_i] = 
            if(e.length == 6)
              Candlestick.new(*e[1..4], v: e.last)
            else
              Candlestick.new(*e[1..4])
            end
        end

        self.new(candles)
      end
    end
  end
end
