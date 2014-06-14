require 'csv'

module Arbalest
  class Simulator
    attr_reader :pilot, :account, :chart

    def initialize(pilot, account)
      @pilot = pilot
      @account = account
    end

    def load(file_path, chart_name)
      data = []
      CSV.foreach(file_path) do |row|
        data << Parsers::MT4.parse(row)
      end
      @chart = Chart.new(data, chart_name)
    end

    def play
      chart.replay do |data|
        pilot.react(data)
        account.manage_positions(data)
      end
    end

    def shoot(order)
      account.open(order)
    end
  end
end
