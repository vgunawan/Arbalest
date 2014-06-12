module Arbalest
  module Strategies
    class DailyMomentum
      attr_reader :stop, :limit_l, :limit_h, :trail, :signal_pips

      def initialize(stop: 15, limit_l: 15, limit_h: 30, signal_pips: 40, trail: 10)
        @stop = stop
        @limit_l = limit_l
        @limit_h = limit_h
        @signal_pips = signal_pips
        @trail = trail
      end

      def process(chart)
        consider_new_position(chart.last(day))
      end

      class << self
        def indicators
          @indicators ||= [
            Indicators::MomentumA
          ]
        end
      end

      private
      def hours
        60
      end

      def day
        24 * hours
      end

      def eight_hours
        8 * hours
      end

      def consider_new_position(data)
        suggestions = DailyMomentum.indicators.map do |i|
          i.calculate(data, signal_pips)
        end.compact

        if valid?(suggestions)
          return order_to_open(suggestions)
        end
        return nil
      end

      def valid?(suggestions)
        return false if suggestions.nil?
        suggestions.size == 1
      end

      def order_to_open(suggestions)
        s = suggestions.first
        Order.new(s[:long], s[:short], eight_hours, limit_h, stop, trail)
      end
    end
  end
end
