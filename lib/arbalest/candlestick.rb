module Arbalest
  class Candlestick
    attr_reader :o, :h, :l, :c, :v
    alias_method :open, :o
    alias_method :high, :h
    alias_method :low, :l
    alias_method :close, :c
    alias_method :volume, :v
    
    def initialize(o: 0, h: 0, l: 0, c: 0, v: 0)
      @o = o
      @h = h
      @l = l
      @c = c
      @v = v
      raise 'open and close must be within low and high' if !valid?
    end

    def ==(other)
      o == other.o and h == other.h and l == other.l and c == other.c and v == other.v
    end

    private
    def valid?
      [@o, @c].inject(true) { |memo, v| memo and v <= @h and v >= @l }
    end
  end
end
