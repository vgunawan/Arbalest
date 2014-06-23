module Arbalest
  class Order
    attr_reader :pair, :long, :short, :time_limit, :limit, :stop, :trail, :at

    def initialize(pair, long, short, at, time_limit: nil, limit: nil, stop: nil, trail: nil)
      @pair = pair
      @long = long
      @short = short
      @time_limit = time_limit
      @limit = limit
      @stop = stop
      @trail = trail
      @at = at
    end

    def fill(data)
      positions = []
      positions <<  new_position(:long, long, data.timestamp) if data.hit?(long)
      positions <<  new_position(:short, short, data.timestamp) if data.hit?(short)
      positions
    end

    def ==(other)
      pair == other.pair and
      long == other.long and 
      short == other.short and
      time_limit == other.time_limit and
      limit == other.limit and
      stop == other.stop and
      trail == trail and
      at == at
    end
    
    private
    def new_position(direction, price, timestamp)
      Position.new(pair, direction, price, timestamp, self)
    end
  end
end
