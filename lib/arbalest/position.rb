module Arbalest
  class Position
    attr_reader :id, :pair, :direction, :price, :time, :status
    def initialize(pair, direction, price, time)
      @pair = pair
      @direction = direction
      @price = price
      @time = time
      @status = :open
      @id = SecureRandom.uuid
    end
  end
end
