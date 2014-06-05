module Arbalest
  class Chart
    attr_reader :data

    def initialize(list)
      @data  = []
      list.each do |e| 
        params = e.select { |k,v| [:o, :h, :l, :c, :v].include? k }
        @data << { timestamp: e[:timestamp], candle: Candlestick.new(params) }
      end
    end

    def at(time)
      i = @data.find_index { |c| c[:timestamp] > time.to_i }
      return nil if i < 1
      @data[i-1][:candle]
    end

  end
end
