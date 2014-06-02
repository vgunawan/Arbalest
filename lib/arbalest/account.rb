module Arbalest
  class Account
    attr_reader :balance
    
    def initialize(balance)
      @balance = balance
    end

    def open(pair, direction, price, time)
      Position.new(pair, direction, price, time)
    end
  end
end
