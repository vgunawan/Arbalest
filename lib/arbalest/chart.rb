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
          params = e.select { |k,v| [:o, :h, :l, :c, :v].include? k }
          candles[e[:timestamp]] = Candlestick.new(params)
        end

        self.new(candles)
      end
    end
  end
end
