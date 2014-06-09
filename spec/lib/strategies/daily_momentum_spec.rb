module Arbalest::Strategies
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
        signal: signal,
        trail: trail
      }}
      let(:chart) { double('audusd') }

      subject { DailyMomentum.new(settings) }

      it("stop") { expect(subject.stop).to eq(stop) }
      it("limit_l") { expect(subject.limit_l).to eq(limit_l) }
      it("limit_h") { expect(subject.limit_h).to eq(limit_h) }
      it("signal") { expect(subject.signal).to eq(signal) }
      it("trail") { expect(subject.trail).to eq(trail) }

      describe "#manage" do
        before do
          subject.manage(account, chart)
        end

        it("account") { expect(subject.account).to eq(account) }
        it("chart") { expect(subject.chart).to eq(chart) }
      end

      describe "#chart_updated" do
        let(:day) { 24 * 60 }
        let(:chart) do
          c = double('audusd')
          allow(c).to receive(:last).with(day)
          c
        end

        before do
          subject.manage(account, chart)
          subject.chart_updated
        end

        it("asks chart for the last daily range") do
          expect(chart).to have_received(:last).with(day)
        end

        it("finds the opening price") do
        end 
      end
    end  
  end
end
