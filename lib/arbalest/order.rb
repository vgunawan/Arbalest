module Arbalest
  class Order
    attr_reader :long, :short, :time_limit, :limit, :stop, :trail, :at

    def initialize(long, short, time_limit, limit, stop, trail, at)
      @long = long
      @short = short
      @time_limit = time_limit
      @limit = limit
      @stop = stop
      @trail = trail
      @at = at
    end

    def ==(other)
      long == other.long and 
      short == other.short and
      time_limit == other.time_limit and
      limit == other.limit and
      stop == other.stop and
      trail == trail
    end
  end
end
