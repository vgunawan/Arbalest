module Arbalest
  class Chart
    attr_reader :data, :name, :interval

    def initialize(list, name, interval)
      @name = name
      @data  = []
      @interval = interval
      @index = {}
      list.each do |e| 
        params = e.select { |k,v| [:o, :h, :l, :c, :v].include? k }
        @data << { 
          timestamp: e[:timestamp], 
          candle: Candlestick.new(params) 
        }
      end
      rebuild_index!
    end

    def at(time)
      i = nearest_index_at(time)
      return nil if i.nil?
      data[i][:candle]
    end

    def range(from, to)
      i = nearest_index_at(from) || 0
      j = nearest_index_at(to) || 0

      return nil if i.nil? and j.nil?
      data[i..j]  
    end

    def last(distance=nil)
      to = data.last[:timestamp]
      from = distance.nil? ? to : to - distance
      range(from, to)
    end
    
    def replay(options=nil, &block)
      raise 'incorrect usage, block is needed' unless block_given?
      new_chart = Chart.new([], name, interval)
      data.each do |d|
        new_chart << d
        yield new_chart
      end
    end

    def elapsed?(time)
      data[-1][:timestamp] + interval > time.to_i
    end

    def <<(other)
      other_data = 
        if other.instance_of?(Chart)
          other.data
        elsif other.instance_of?(Array)
          other
        else
          []
        end
      data << other_data
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
