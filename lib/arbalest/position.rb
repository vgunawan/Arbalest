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

    def close_if_hit!(chart)
      last_data = chart.last[0]
      if last_data.hit?(limit)
        close(:limit_hit, limit)
      elsif last_data.hit?(stop)
        close(:stop_hit, stop)
      elsif chart.elapsed?(time_limit)
        close(:time_limit, last_data.close)
      end
    end

    private
    def limit
      op = (direction == :long) ? :+ : :-
      opening_price.send(op, pair.one_pip * order.limit)
    end

    def stop
      op = (direction == :long) ? :- : :+
      opening_price.send(op, pair.one_pip * order.stop)
    end

    def time_limit
      time + order.time_limit
    end
  end
end
