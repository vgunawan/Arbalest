require 'spec_helper'

module Arbalest
  describe Data do
    let(:timestamp) { Time.parse('2014-01-01T13:00').to_i }
    let(:candlestick) do
      Candlestick.new(o: 100, h: 103, l: 98, c: 101)
    end

    subject { Data.new(timestamp, candlestick) }

    it('timestamp') { expect(subject.timestamp).to eq(timestamp) }
    it('candlestick') { expect(subject.candlestick).to eq(candlestick) }

    describe '#hit' do
      context 'with price out of the range' do
        let(:price) { 200 }

        it 'returns false' do
          expect(subject.hit(price)).to be_false
        end
      end

      context 'with price in the range' do
        let(:price) { 103 }

        it 'returns true' do
          expect(subject.hit(price)).to be_true
        end
      end
    end
  end
end
