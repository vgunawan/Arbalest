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
        elsif pos.limit_hit?(data[:candlestick])
          pos.close(:limit_hit, pos.limit)
          history << pos
          return true
        elsif pos.stop_hit?(data[:cadlestick])
          pos.close(:stop_hit, pos.stop)
          history << pos
          return true
        end
        false
      end
    end
  end
end
