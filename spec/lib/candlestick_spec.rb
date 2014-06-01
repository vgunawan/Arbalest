require 'spec_helper'

module Arbalest
  describe Candlestick do
    let(:open) { 170 }
    let(:high) { 190 }
    let(:low)  { 160 }
    let(:close) { 180 }
    let(:volume) { 200 }
    subject { Candlestick.new(o: open, h: high, l: low, c: close, v: volume) }

    it("#open") { expect(subject.open).to eq(open) }
    it("#high") { expect(subject.high).to eq(high) }
    it("#low") { expect(subject.low).to eq(low) }
    it("#close") { expect(subject.close).to eq(close) }
    it("#volume") { expect(subject.volume).to eq(volume) } 
    
    describe "#initialize" do
      context "with open above high" do
        let(:open) { 191 }
        
        it("fails") do 
          expect{subject}.to raise_error 'open and close must be within low and high'
        end
      end
      
      context "with open equals high" do
        let(:open) { 190 }        
        
        it("fails") do 
          expect{subject}.to_not raise_error
        end
      end

      context "with open below low" do
        let(:open) { 159 }        
        
        it("fails") do 
          expect{subject}.to raise_error 'open and close must be within low and high'
        end
      end

      context "with open equals low" do
        let(:open) { 160 }        
        
        it("fails") do 
          expect{subject}.to_not raise_error
        end
      end

      context "with close above high" do
        let(:close) { 191 }        
        
        it("fails") do 
          expect{subject}.to raise_error 'open and close must be within low and high'
        end
      end
      
      context "with close equals high" do
        let(:close) { 190 }        
        
        it("fails") do 
          expect{subject}.to_not raise_error
        end
      end

      context "with close below low" do
        let(:close) { 159 }        
        
        it("fails") do 
          expect{subject}.to raise_error 'open and close must be within low and high'
        end
      end

      context "with close equals low" do
        let(:close) { 160 }        
        
        it("fails") do 
          expect{subject}.to_not raise_error
        end
      end

      context "unspecified volume" do
        subject { Candlestick.new(o: open, h: high, l: low, c: close) }

        it("volume") { expect(subject.volume).to be_zero }
      end
    end

    it("==") { expect(subject).to eq(Candlestick.new(o: open, h: high, l: low, c: close, v:volume)) }
  end
end
