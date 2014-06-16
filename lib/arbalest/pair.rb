module Arbalest
  class Pair
    attr_reader :name, :one_pip, :spread

    def initialize(name, one_pip, spread)
      @name = name
      @one_pip = one_pip
      @spread = spread
    end

    def ==(other)
      name == other.name and
      one_pip == other.one_pip and
      spread == other.spread
    end
  end
end
