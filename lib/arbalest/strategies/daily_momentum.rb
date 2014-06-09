module Arbalest::Strategies
  class DailyMomentum
    attr_reader :stop, :limit_l, :limit_h, :trail, :signal_pips
    attr_reader :account, :chart
    def initialize(stop: 15, limit_l: 15, limit_h: 30, signal_pips: 40, trail: 10)
      @stop = stop
      @limit_l = limit_l
      @limit_h = limit_h
      @signal_pips = signal_pips
      @trail = trail
    end

    def manage(account, chart)
      @account = account
      @chart = chart
    end

    def chart_updated
      @data = chart.last(day)

      consider_new_position!
    end

    private
    def day
      @day ||= 24 * 60
    end
    
    def consider_new_position!
      directions = indicators.map do |i|
        i.calculate(signal_data, signal_pips)
      end.compact!

      if contradicts(directions)
        return false
      end
      account.
        open(chart.name, directions.first, current_data[:candle].open, current_data[:time])
      return true
    end

    def indicators
      @indicators ||= []
    end

    def contradicts(directions)
      return true if directions.nil?
      directions.uniq.size > 1
    end

    def signal_data
      @data[0..-2]
    end

    def current_data
      @data.first
    end
  end
end
