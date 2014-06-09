module Arbalest
  class Account
    attr_reader :balance, :positions
    
    def initialize(balance=0)
      @balance = balance
      @positions = []
    end

    def open(pair, direction, price, time)
      p = Position.new(pair, direction, price, time)
      @positions << p
      p
    end
    
    def update_positions(data)
    end

    private
    def time_limits!
    end

    def stops!
    end

    def limits!
    end
  end
end
