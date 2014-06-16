module Arbalest
  class Pair
    attr_reader :name, :one_pip, :spread

    def initialize(name, one_pip, spread)
      @name = name
      @one_pip = one_pip
      @spread = spread
    end
  end
end
