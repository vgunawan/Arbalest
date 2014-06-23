require 'spec_helper'

module Arbalest
  describe Order do
    let(:pair) { double('audjpy') }
    let(:long) { 107.823 }
    let(:short) { 107.323 }
    let(:time_limit) { 24 * 60 }
    let(:limit) { 30 }
    let(:stop) { 15 }
    let(:trail) { 10 }
    let(:at) { Time.parse('2014-01-01T13:00') }
    
    subject { Order.new(pair, long, short, at, time_limit: time_limit, limit: limit, 
                        stop: stop, trail: trail) }

    it('pair') { expect(subject.pair).to eq(pair) }
    it('long') { expect(subject.long).to eq(long) }
    it('short') { expect(subject.short).to eq(short) }
    it('time_limit') { expect(subject.time_limit).to eq(time_limit) }
    it('limit') { expect(subject.limit).to eq(limit) }
    it('stop') { expect(subject.stop).to eq(stop) }
    it('trail') { expect(subject.trail).to eq(trail) }
    it('at') { expect(subject.at).to eq(at) }

    describe '#fill' do
      let(:timestamp) { 1 } 
      let(:data) { double('data', timestamp: timestamp) }
      let(:expected_long) { Position.new(pair, :short, short, timestamp, subject) }
      let(:expected_short) { Position.new(pair, :long, long, timestamp, subject) }

      it 'successfully on short side' do
        allow(data).to receive(:hit?).with(long).and_return(false)
        allow(data).to receive(:hit?).with(short).and_return(true)
        expect(subject.fill(data).first).to eq(expected_long)
      end
      
      it 'successfully on long side' do
        allow(data).to receive(:hit?).with(long).and_return(true)
        allow(data).to receive(:hit?).with(short).and_return(false)
        expect(subject.fill(data).first).to eq(expected_short)
      end

      it 'successfully on both long and short' do
        allow(data).to receive(:hit?).with(long).and_return(true)
        allow(data).to receive(:hit?).with(short).and_return(true)
        expect(subject.fill(data)).to eq([expected_short, expected_long])
      end

      it 'not succesful' do
        allow(data).to receive(:hit?).with(long).and_return(false)
        allow(data).to receive(:hit?).with(short).and_return(false)
        expect(subject.fill(data)).to be_empty
      end
    end

    describe '==' do
      it('equals') do
        test = Order.new(pair, long, short, at, time_limit: time_limit, limit: limit, stop: 
                         stop, trail: trail)
        expect(subject).to eq(test)
      end

      it('not equals') do 
        test = Order.new(pair, long, short, at, time_limit: 60, limit: limit, 
                         stop: stop, trail: trail )
        expect(subject).to_not eq(test)
      end
    end
  end
end
