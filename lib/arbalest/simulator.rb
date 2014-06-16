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
      @chart = Chart.new(data, chart_name, interval(data))
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

    private
    def interval(data)
      return nil if data.size < 2
      data[1][:timestamp] - data[0][:timestamp]
    end
  end
end
