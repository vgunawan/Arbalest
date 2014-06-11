require 'spec_helper'
require 'csv'

module Arbalest
  describe Simulator do
    let(:pilot) { double('Sagara') }
    let(:account) { double('cfd_account') }
    subject { Simulator.new(pilot, account) }

    describe "#load" do
      let(:path) { 'somepath' }
      let(:data) { double('chartdata') }
      let(:csv) { double('csv') }
      let(:chartname) { 'gbpjpy15m' }

      before do
        CSV.stub(:foreach).with(path).and_yield(csv)
        Parsers::MT4.stub(:parse).and_return(data)
        Chart.stub(:new).with([data], chartname)
        subject.load(path, chartname)
      end

      it 'calls csv to read the data' do
        expect(CSV).to have_received(:foreach).with(path)
      end

      it 'sets a new chart based on the csv' do
        expect(Chart).to have_received(:new).with([data], chartname)
      end
    end
  end
end
