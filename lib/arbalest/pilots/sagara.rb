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
        simulator.shoot(order)
      end
    end
  end
end
