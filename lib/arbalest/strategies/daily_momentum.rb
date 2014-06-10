module Arbalest
  module Strategies
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
        consider_new_position(chart.last(day))
      end

      private
      def day
        @day ||= 24 * 60
      end

      def consider_new_position(data)
        suggestions = indicators.map do |i|
          i.calculate(data, signal_pips)
        end.compact!

        if valid?(suggestions)
          return orders_to_open(suggestions)
        end
        return nil
      end

      def indicators
        @indicators ||= [
          Indicators::MomentumA,
          Indicators::MomentumB,
          Indicators::MomentumC
        ]
      end

      def valid?(suggestions)
        return false if suggestions.nil?
        suggestions.size == 1
      end

      def order_to_open(suggestions)
        s = suggestions.first
        { 
          price: { 
            long: s.long,
            short: s.short,
          },
          time_limit: one_day,
          limit: @limit_h,
          stop: @stop,
          trail: @trail
        }
      end
    end
  end
end
