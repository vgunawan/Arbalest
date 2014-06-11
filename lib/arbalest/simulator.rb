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
    end

    def stop
    end
  end
end
