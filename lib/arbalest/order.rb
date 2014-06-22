module Arbalest
  class Order
    attr_reader :long, :short, :time_limit, :limit, :stop, :trail, :at

    def initialize(long, short, at, time_limit: nil, limit: nil, stop: nil, trail: nil)
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
      trail == trail and
      at == at
    end
  end
end
