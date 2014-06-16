module Arbalest
  describe Pair do
    let(:name) { :gbpjpy }
    let(:one_pip) { 0.0001 }
    let(:spread) { 3.7 } 
    subject { Pair.new(name, one_pip, spread) }

    it('name') { expect(subject.name).to eq(name) }
    it('one_pip') { expect(subject.one_pip).to eq(one_pip) }
    it('spread') { expect(subject.spread).to eq(spread) }
    
    describe '#==' do
      context 'equals' do
        let(:other) { Pair.new(name, one_pip, spread) }
        
        it 'returns true' do
          expect(subject).to eq(other)
        end
      end

      context 'inequals' do
        let(:other) { Pair.new(:audusd, 0.01, 1.0) }

        it 'returns false' do
          expect(subject).to_not eq(other)
        end
      end
    end
  end
end
