require 'spec_helper'

module Arbalest
  describe Position do
    let(:pair) { :eurchf }
    let(:direction) { :long }
    let(:price) { 1.23425 }
    let(:time) { Time.parse("2014-01-01T00:01:45") }

    subject { Position.new(pair, direction, price, time) }
    
    it("pair") { expect(subject.pair).to eq(pair) }
    it("direction") { expect(subject.direction).to eq(direction) }
    it("price") { expect(subject.price).to eq(price) }
    it("time") { expect(subject.time).to eq(time) }
    it("status") { expect(subject.status).to eq(:open) }
  end
end
