module Arbalest::Pilots
  class Sagara
    attr_reader :strategy, :simulator

    def initialize(strategy, simulator)
      @strategy = strategy
      @simulator = simulator
    end

    def react(chart)
      order = strategy.process(chart)
      unless order.nil?
        simulator.place_order(order)
      end
    end
  end
end
