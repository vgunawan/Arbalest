require 'spec_helper'

module Arbalest
  describe Order do
    let(:long) { 107.823 }
    let(:short) { 107.323 }
    let(:time_limit) { 24 * 60 }
    let(:limit) { 30 }
    let(:stop) { 15 }
    let(:trail) { 10 }
    let(:at) { Time.parse('2014-01-01T13:00') }
    
    subject { Order.new(long, short, at, time_limit: time_limit, limit: limit, 
                        stop: stop, trail: trail) }

    it('long') { expect(subject.long).to eq(long) }
    it('short') { expect(subject.short).to eq(short) }
    it('time_limit') { expect(subject.time_limit).to eq(time_limit) }
    it('limit') { expect(subject.limit).to eq(limit) }
    it('stop') { expect(subject.stop).to eq(stop) }
    it('trail') { expect(subject.trail).to eq(trail) }
    it('at') { expect(subject.at).to eq(at) }

    describe '==' do
      it('equals') do
        test = Order.new(long, short, at, time_limit: time_limit, limit: limit, stop: 
                         stop, trail: trail)
        expect(subject).to eq(test)
      end

      it('not equals') do 
        test = Order.new(long, short, at, time_limit: 60, limit: limit, 
                         stop: stop, trail: trail )
        expect(subject).to_not eq(test)
      end
    end
  end
end
