module Arbalest
  class Position
    attr_reader :id, :pair, :direction, :closing_price
    attr_reader :price, :time, :status
    
    def initialize(pair, direction, price, time)
      @pair = pair
      @direction = direction
      @price = price
      @time = time
      @status = :open
      @id = SecureRandom.uuid
    end

    def close(closing_price)
      @status = :close
      @closing_price = closing_price
    end
  end
end
