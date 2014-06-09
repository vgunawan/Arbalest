module Arbalest::Strategies
  class DailyMomentum
    attr_reader :stop, :limit_l, :limit_h, :trail, :signal
    attr_reader :account, :chart
    def initialize(stop: 15, limit_l: 15, limit_h: 30, signal: 40, trail: 10)
      @stop = stop
      @limit_l = limit_l
      @limit_h = limit_h
      @signal = signal
      @trail = trail
    end

    def manage(account, chart)
      @account = account
      @chart = chart
    end

    def chart_updated
      data = chart.last(day)
    end

    private
    def day
      @day ||= 24 * 60
    end
  end
end
