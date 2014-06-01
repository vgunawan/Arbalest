module Arbalest
  class Candlestick
    attr_reader :o, :h, :l, :c, :v
    alias_method :open, :o
    alias_method :high, :h
    alias_method :low, :l
    alias_method :close, :c
    alias_method :volume, :v
    
    def initialize(o, h, l, c, v)
      @o = o
      @h = h
      @l = l
      @c = c
      @v = v
    end
  end
end
