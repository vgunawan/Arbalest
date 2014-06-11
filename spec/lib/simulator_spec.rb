require 'spec_helper'
require 'csv'

module Arbalest
  describe Simulator do
    let(:pilot) { double('Sagara') }
    let(:account) { double('cfd_account') }
    subject { Simulator.new(pilot, account) }

    describe "#load" do
      let(:path) { 'somepath' }
      before do
        CSV.stub(:foreach).with(path)
        subject.load(path)
      end

      it 'loads the data' do
        expect(CSV).to have_received(:foreach).with(path)
      end
    end
  end
end
