module Arbalest
  describe Order do
    let(:long) { 107.823 }
    let(:short) { 107.323 }
    let(:time_limit) { 24 * 60 }
    let(:limit) { 30 }
    let(:stop) { 15 }
    let(:trail) { 10 }
    
    subject { Order.new(long, short, time_limit, limit, stop, trail) }

    it('long') { expect(subject.long).to eq(long) }
    it('short') { expect(subject.short).to eq(short) }
    it('time_limit') { expect(subject.time_limit).to eq(time_limit) }
    it('limit') { expect(subject.limit).to eq(limit) }
    it('stop') { expect(subject.stop).to eq(stop) }
    it('trail') { expect(subject.trail).to eq(trail) }

    describe '==' do
      it('equals') do
        test = subject
        expect(subject).to eq(test)
      end

      it('not equals') do 
        test = Order.new(long, short, 60, limit, stop, trail)
        expect(subject).to_not eq(test)
      end
    end
  end
end
