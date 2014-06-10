module Arbalest::Indicators
  class MomentumA
    class << self
      def calculate(data, signal_pips)
        open_price = data.first[:candlestick].open
        close_price = data.last[:candlestick].close
        delta = open_price - close_price
        if delta.abs <= signal_pips
          return nil
        end
        direction = delta < 0 ? :long : :short
        h = {}
        h[direction] = close_price
        h
      end
    end
  end
end
