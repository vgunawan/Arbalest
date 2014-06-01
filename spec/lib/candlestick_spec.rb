require 'spec_helper'

module Arbalest
  describe Candlestick do
    let(:open) { 170 }
    let(:high) { 172 }
    let(:low)  { 169 }
    let(:close) { 171 }
    let(:volume) { 200 }
    subject { Candlestick.new(open, high, low, close, v: volume) }

    it("#open") { expect(subject.open).to eq(open) }
    it("#high") { expect(subject.high).to eq(high) }
    it("#low") { expect(subject.low).to eq(low) }
    it("#close") { expect(subject.close).to eq(close) }
    it("#volume") { expect(subject.volume).to eq(volume) } 
    
    describe "#initialize" do
      context "invalid opens" do
        it("above high") { fail }
        it("below low") { fail }
      end

      context "invalid closes" do
        it("above high") { fail }
        it("below low") { fail }
      end

      context "unspecified volume" do
        subject { Candlestick.new(open, high, low, close) }

        it("volume") { expect(subject.volume).to be_zero }
      end
    end
    it("==") { expect(subject).to eq(Candlestick.new(open, high, low, close, v:volume)) }
  end
end
