module Arbalest
  class Position
    attr_reader :pair, :direction, :closing_price
    attr_reader :price, :time, :status, :strategy
    
    def initialize(pair, direction, price, time)
      @pair = pair
      @direction = direction
      @price = price
      @time = time
      @status = :open
    end

    def close(closing_price)
      @status = :close
      @closing_price = closing_price
    end
  end
end
