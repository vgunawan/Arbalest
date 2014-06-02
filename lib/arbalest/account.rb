module Arbalest
  class Account
    attr_reader :balance, :positions
    
    def initialize(balance)
      @balance = balance
      @positions = []
    end

    def open(pair, direction, price, time)
      p = Position.new(pair, direction, price, time)
      @positions << p
      p
    end
  end
end
