require 'spec_helper.rb'

module Arbalest
  module Strategies
    describe DailyMomentum do
      describe "#manage" do
        let(:account) { double('cfd_account')}
        let(:stop) { 15 }
        let(:limit_l) { 20 }
        let(:limit_h) { 40 }
        let(:trail) { 10 }
        let(:signal) { 26 }
        let(:settings) {{
          stop: stop,
          limit_l: limit_l,
          limit_h: limit_h,
          signal_pips: signal,
          trail: trail
        }}
        let(:chart) { double('audusd') }

        subject { DailyMomentum.new(settings) }

        it("stop") { expect(subject.stop).to eq(stop) }
        it("limit_l") { expect(subject.limit_l).to eq(limit_l) }
        it("limit_h") { expect(subject.limit_h).to eq(limit_h) }
        it("signal_pips") { expect(subject.signal_pips).to eq(signal) }
        it("trail") { expect(subject.trail).to eq(trail) }

        def candle(seed)
          Candlestick.new({
            o: 1.0000 + seed * 0.0001,
            h: 1.0050 + seed * 0.0001,
            l: 0.9900 + seed * 0.0001,
            c: 0.9950 + seed * 0.0001,
            v: 100 * seed
          })
        end

        def timestamp(seed)
          Time.parse("2014-01-01T:13:00:00").to_i + seed * 3600
        end

        describe "#manage" do
          before do
            subject.manage(account, chart)
          end

          it("account") { expect(subject.account).to eq(account) }
          it("chart") { expect(subject.chart).to eq(chart) }
        end

        describe "#chart_updated" do
          let(:day) { 24 * 60 }

          let(:data) do 
            d = double('data')
            allow(d).to receive(:last).
              and_return({ timestamp: timestamp(23), candlestick: candle(23) })
            d
          end

          let(:chart) do
            c = double('audusd')
            allow(c).to receive(:last).with(day).and_return(data)
            allow(c).to receive(:name).and_return('gbpjpy5m')
            c
          end

          let(:account) do
            a = double('cfd account')
            allow(a).to receive(:open)
            a
          end

          before do
            subject.manage(account, chart)
          end

          context "with no order from indicators" do
            before do
              Indicators::MomentumA.should_receive(:calculate).and_return(nil)
              @new_orders = subject.chart_updated
            end

            it("asks chart for the last daily range") do
              expect(chart).to have_received(:last).with(day)
            end

            it "returns no new order" do
              expect(@new_orders).to be_nil
            end
          end

          context "with new order from indicators" do
            let(:short_level) { 91.32 }
            let(:short_order) { { short: short_level } }

            before do
              Indicators::MomentumA.should_receive(:calculate).and_return(short_order)
              @new_orders = subject.chart_updated
            end

            it 'returns new short order' do
              expect(@new_orders).to eq({
                price: {
                  long: nil,
                  short: short_level
                },
                time_limit: 8 * 60,
                limit: limit_h,
                stop: stop,
                trail: trail
              })
            end
          end

        end
      end  
    end
  end
end
