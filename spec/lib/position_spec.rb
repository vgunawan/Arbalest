require 'spec_helper'

module Arbalest
  describe Position do
    let(:pair) { :eurchf }
    let(:direction) { :long }
    let(:price) { 1.23425 }
    let(:time) { Time.parse("2014-01-01T00:01:45") }
    let(:strategy) { Strategies::DailyMomentum }

    subject { Position.new(pair, direction, price, time, strategy) }
    
    it("pair") { expect(subject.pair).to eq(pair) }
    it("direction") { expect(subject.direction).to eq(direction) }
    it("price") { expect(subject.price).to eq(price) }
    it("time") { expect(subject.time).to eq(time) }
    it("status") { expect(subject.status).to eq(:open) }
    it("strategy") { expect(subject.strategy).to be(strategy) }

    describe "#close" do
      let(:closing_price) { 1.00 }

      before do
        subject.close(closing_price)
      end

      it "sets status to close" do
        expect(subject.status).to eq(:close)  
      end

      it "sets the closing price" do
        expect(subject.closing_price).to eq(closing_price)
      end
    end
  end
end
