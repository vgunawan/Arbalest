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
      manage_existings(chart.last, chart.pair)
    end

    private
    def manage_existings(data, pair)
      positions.delete_if do |pos|
        if pos.pair != pair
          return false
        elsif pos.close_if_hit!(data)
          history << pos
          return true
        else
          pos.update_trail_stop(data[:candlestick])
          return false
        end
      end
    end
  end
end
