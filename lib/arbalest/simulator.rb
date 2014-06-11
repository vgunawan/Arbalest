require 'csv'

module Arbalest
  class Simulator
    attr_reader :data, :pilot, :account

    def initialize(pilot, account)
      @pilot = pilot
      @account = account
    end

    def load(file_path)
      data = []
      CSV.foreach(file_path) do |row|
        data << MT4.parse(row)
      end
    end

    def play
    end

    def stop
    end
  end
end
