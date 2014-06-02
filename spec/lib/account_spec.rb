module Arbalest
  describe Account do
    let(:balance) { 100 }
    subject { Account.new(balance) }

    it "#balance" do
      expect(subject.balance).to eq(balance)
    end

    describe "open a new position" do
      let(:price) { 0.98432 }
      let(:time) { Time.parse("2014-05-02T00:03:45") }
      let(:new_position) { subject.open(:audusd, :long, price, time) }
      it "adds a new position as 'open'" do
        expect(new_position.status).to eq(:open)
      end

      it "adds the position to the collection" do
        size = subject.positions.size
        new_position
        expect(subject.positions.size).to eq(size+1)
      end

      it "returns the position instance" do
        expect(new_position).to be_an_instance_of(Position)
      end
    end

    describe "close a position" do
    end

    describe "all closed positions" do
    end

    describe "all open positions" do

    end

    describe "bankrupt" do

    end
  end
end
