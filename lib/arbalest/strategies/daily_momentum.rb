module Arbalest::Strategies
  class DailyMomentum
    attr_reader :stop, :limit_l, :limit_h, :trail

    def initialize(stop: 15, limit_l: 15, limit_h: 30, trail: 10)
      @stop = stop
      @limit_l = limit_l
      @limit_h = limit_h
      @trail = trail
    end

    def manage(account, chart)
      @account = account
      @chart = chart
    end
  end
end
