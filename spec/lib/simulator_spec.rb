require 'spec_helper'
require 'csv'

module Arbalest
  describe Simulator do
    let(:pilot) { double('Sagara') }
    let(:account) { double('cfd_account') }
    let(:path) { 'somepath' }
    let(:data) { double('chartdata') }
    let(:csv) { double('csv') }
    let(:chartname) { 'gbpjpy15m' }
    let(:chart) { double('chart') }

    subject { Simulator.new(pilot, account) }

    def setup_simulator
      CSV.stub(:foreach).with(path).and_yield(csv)
      Parsers::MT4.stub(:parse).and_return(data)
      Chart.stub(:new).with([data], chartname).and_return(chart)
    end

    describe "#load" do
      before do
        setup_simulator
        subject.load(path, chartname)
      end

      it 'calls csv to read the data' do
        expect(CSV).to have_received(:foreach).with(path)
      end

      it 'sets a new chart based on the csv' do
        expect(Chart).to have_received(:new).with([data], chartname)
      end
    end

    describe '#shoot' do
      let(:order) { double('order') }

      before do
        account.stub(:open).with(order)
        subject.shoot(order)
      end

      it 'tells account to open an order' do
        expect(account).to have_received(:open).with(order)
      end
    end

    describe "#play" do
      before do
        subject.stub(:chart).and_return(chart)
        chart.stub(:replay).and_yield(data)
        pilot.stub(:react)
        allow(account).to receive(:manage_positions).with(data)
        subject.play
      end

      it 'replays the chart from the beginning' do
        expect(chart).to have_received(:replay)
      end

      it 'expect the player to react' do
        expect(pilot).to have_received(:react)
      end

      it 'expect the account to manage any open positions' do
        expect(account).to have_received(:manage_positions)
      end
    end
  end
end
