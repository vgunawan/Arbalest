module Arbalest
  class Chart
    attr_reader :data

    def initialize(list)
      @data  = []
      @index = {}
      list.each do |e| 
        params = e.select { |k,v| [:o, :h, :l, :c, :v].include? k }
        @data << { timestamp: e[:timestamp], candle: Candlestick.new(params) }
        rebuild_index!
      end
    end

    def at(time)
      i = nearest_index_at(time)
      return nil if i.nil?
      data[i][:candle]
    end

    def range(from, to)
      i = nearest_index_at(from)
      j = nearest_index_at(to)
      return nil if i.nil? or j.nil?
      data[i..j]  
    end

    private
    #assuming data is sorted
    def nearest_index_at(time)
      return @index[time.to_i] if @index.key? time.to_i 
      prev_i = -1
      i = data.find_index do |e| 
        prev_i += 1
        e[:timestamp] > time.to_i
      end
      if i.nil?
        return prev_i unless prev_i < 0
        return nil
      elsif i.zero?
        return nil
      end
      i-1
    end

    def rebuild_index!
      @index.clear
      @data.each_with_index { |v, i| @index[v[:timestamp]] = i }
    end
  end
end
