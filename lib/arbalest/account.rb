module Arbalest
  class Account
    attr_reader :balance, :positions, :working_orders
    
    def initialize(balance=0)
      @balance = balance
      @working_orders = []
      @positions = []
    end

    def open(order)
      @working_orders << order
    end
  end
end
