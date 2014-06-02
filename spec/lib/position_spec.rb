require 'spec_helper'

module Arbalest
  describe Position do
    let(:pair) { :eurchf }
    let(:direction) { :long }
    let(:price) { 1.23425 }
    let(:time) { Time.parse("2014-01-01T00:01:45") }
    let(:uuid) { '09113e16-6762-4c42-8c47-6370cf63b754' }

    subject { Position.new(pair, direction, price, time) }
    
    before do
      SecureRandom.stub(:uuid).and_return(uuid)
    end

    it("pair") { expect(subject.pair).to eq(pair) }
    it("direction") { expect(subject.direction).to eq(direction) }
    it("price") { expect(subject.price).to eq(price) }
    it("time") { expect(subject.time).to eq(time) }
    it("status") { expect(subject.status).to eq(:open) }
    it("id") { expect(subject.id).to eq(uuid) }

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
