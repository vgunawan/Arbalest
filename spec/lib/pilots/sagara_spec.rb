require 'spec_helper'

module Arbalest::Pilots
  describe Sagara do
    let(:strategy) { double('strategy') }
    let(:simulator) { double('simulator') }

    subject { Sagara.new(strategy, simulator) }

    it('strategy') { expect(subject.strategy).to be(strategy) }
    it('simulator') { expect(subject.simulator).to be(simulator) }

    describe '#react' do
      let(:chart) { double('chart') }
      let(:order) { double('order') }

      before do
        simulator.stub(:place_order).with(order)
      end

      context 'strategy returns no order' do
        before do
          strategy.stub(:process).with(chart).and_return(nil)
          subject.react(chart)
        end

        it 'use the strategy' do
          expect(strategy).to have_received(:process).with(chart)
        end

        it 'does not issue new order' do
          expect(simulator).to_not have_received(:place_order)
        end
      end

      context 'strategy returns order' do
        before do
          strategy.stub(:process).with(chart).and_return(order)
          subject.react(chart)
        end

        it 'issue a new order' do
          expect(simulator).to have_received(:place_order).with(order)
        end
      end
    end
  end
end
