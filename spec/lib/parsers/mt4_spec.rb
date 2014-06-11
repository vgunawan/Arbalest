module Arbalest
  module Parsers
    describe MT4 do
      let(:date)  { '2014.01.20' }
      let(:time)  { '02:15' }
      let(:open)  { '170.76700' }
      let(:high)  { '170.81700' }
      let(:low)   { '170.60000' }
      let(:close) { '170.67800' }
      let(:vol)   { '769' }

      subject { MT4 }

      describe '#parse' do
        let(:expected) do
          {
            timestamp: Time.parse("#{date}T#{time}").to_i,
            o: open.to_f,
            h: high.to_f,
            l: low.to_f,
            c: close.to_f,
            v: vol.to_i
          }
        end
        let(:row) do
          [date, time, open, high, low, close, vol]
        end

        it 'returns hash in the right format' do
          expect(subject.parse(row)).to eq(expected)
        end

        context 'no volume data' do
          let(:expected) do
            {
              timestamp: Time.parse("#{date}T#{time}").to_i,
              o: open.to_f,
              h: high.to_f,
              l: low.to_f,
              c: close.to_f
            }
          end
          let(:row) do
            [date, time, open, high, low, close]
          end

          it 'returns hash with no volume' do
            expect(subject.parse(row)).to eq(expected)
          end
        end

        context 'no data is given' do
          let(:row) { [] }
          
          it 'returns nil' do
            expect(subject.parse(row)).to be_nil
          end
        end
      end
    end
  end
end
