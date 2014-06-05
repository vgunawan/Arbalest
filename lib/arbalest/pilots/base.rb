module Arbalest::Pilots
  class Base
    attr_reader :chart_data, :interval, :limit, :stop, :trail
    
    def initialize(chart_data, interval, limit, stop, trail)
      @chart_data = chart_data
      @interval = interval
      @limit = limit
      @stop = stop
      @trail = trail
    end
  end
end
