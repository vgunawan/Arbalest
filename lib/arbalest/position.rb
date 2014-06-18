module Arbalest
  class Position
    attr_reader :pair, :direction, :closing_price, :order
    attr_reader :opening_price, :time, :status, :strategy
    
    def initialize(pair, direction, opening_price, time, order)
      @pair = pair
      @direction = direction
      @opening_price = opening_price
      @time = time
      @status = :open
      @order = order
    end

    def close(status, closing_price)
      @status = status
      @closing_price = closing_price
    end

    def stop_price
      return nil unless order.stop
      op = (direction == :long) ? :- : :+
      @stop_price ||= opening_price.send(op, pair.one_pip * order.stop)
    end

    def limit_price
      return nil unless order.limit
      op = (direction == :long) ? :+ : :-
      @limit_price ||= opening_price.send(op, pair.one_pip * order.limit)
    end

    def close_if_hit!(chart)
      last_data = chart.last.first
      if last_data.hit?(limit_price)
        close(:limit_hit, limit_price)
      elsif last_data.hit?(stop_price)
        close(:stop_hit, stop_price)
      elsif chart.elapsed?(time_limit)
        close(:time_limit, last_data.close)
      end
    end

    def update_trail_stop(chart)
      return unless order.trail
      last_candle = chart.last.first.candlestick
      one_pip = order.one_pip
      trail = order.trail

      if direction == :long
        delta = (last_candle.high - opening_price) / one_pip
        @stop_price = stop_price + (delta.floor / trail).to_i * trail * one_pip
      else
      end
    end

    private
    def time_limit
      time + order.time_limit
    end
  end
end
