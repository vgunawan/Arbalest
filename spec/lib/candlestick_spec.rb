require 'spec_helper'

module Arbalest
  describe Candlestick do
    let(:open) { 170 }
    let(:high) { 172 }
    let(:low)  { 169 }
    let(:close) { 171 }
    let(:volume) { 200 }
    subject { Candlestick.new(open, low, high, close, volume) }

    it("#open") { expect(subject.open).to eq(open) }
  end
end
