module Arbalest
  describe Account do
    let(:balance) { 100 }
    subject { Account.new(balance) }

    it "#balance" do
      expect(subject.balance).to eq(balance)
    end

    describe "position" do
      let(:price) { 0.98432 }
      let(:time) { Time.parse("2014-05-02T00:03:45") }
      let(:new_position) { subject.open(:audusd, :long, price, time) }
      
      def have_an_open_position
        new_position
      end

      describe "#open" do

        it "status is 'open'" do
          expect(new_position.status).to eq(:open)
        end

        it "adds to the collection" do
          size = subject.positions.size
          have_an_open_position
          expect(subject.positions.size).to eq(size+1)
        end

        it "returns the instance" do
          expect(new_position).to be_an_instance_of(Position)
        end

      end

      describe "all closed positions" do
        it "returns positions" do end
      end

      describe "all open positions" do
        it "returns positions" do end
      end
    end
  end
end
