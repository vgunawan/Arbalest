module Arbalest
  class Position
    attr_reader :pair, :direction, :price, :time, :status
    def initialize(pair, direction, price, time)
      @pair = pair
      @direction = direction
      @price = price
      @time = time
      @status = :open
    end
  end
end
