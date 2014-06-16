module Arbalest
  class Account
    attr_reader :balance, :positions, :working_orders, :history
    
    def initialize(balance=0)
      @balance = balance
      @working_orders = []
      @positions = []
      @history = []
    end

    def open(order)
      @working_orders << order
    end

    def manage_positions(chart)
      manage_existings(chart)
    end

    private
    def manage_existings(chart)
      positions.delete_if do |pos|
        if pos.pair != chart.pair
          return false
        elsif pos.close_if_hit!(chart)
          history << pos
          return true
        else
          pos.update_trail_stop(chart)
          return false
        end
      end
    end
  end
end
