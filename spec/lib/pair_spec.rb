module Arbalest
  describe Pair do
    let(:name) { :gbpjpy }
    let(:one_pip) { 0.0001 }
    let(:spread) { 3.7 } 
    subject { Pair.new(name, one_pip, spread) }

    it('name') { expect(subject.name).to eq(name) }
    it('one_pip') { expect(subject.one_pip).to eq(one_pip) }
    it('spread') { expect(subject.spread).to eq(spread) }
  end
end
