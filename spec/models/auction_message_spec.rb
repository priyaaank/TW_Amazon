require 'spec_helper'

describe AuctionMessage do
  describe "'create'" do
    context "given a running auction" do
      before (:each) do
        @running_auction = SilentAuction.make!
      end

      it "should create a message for an auction"  do
        @auction_message = AuctionMessage.make!(:message => "Test Auction Message", :silent_auction_id => @running_auction.id, :creator => 'dummy_creator')
        @auction_message.save.should be_true
      end


      it "should create multiple auction messages for an auction" do
        @auction_message1 = AuctionMessage.make!(:message => "Test Auction Message 1", :silent_auction_id => @running_auction.id, :creator => 'dummy_creator1')
        @auction_message2 = AuctionMessage.make!(:message => "Test Auction Message 2", :silent_auction_id => @running_auction.id, :creator => 'dummy_creator2')
        @auction_message3 = AuctionMessage.make!(:message => "Test Auction Message 3", :silent_auction_id => @running_auction.id, :creator => 'dummy_creator3')
        @auction_message1.save.should be_true
        @auction_message2.save.should be_true
        @auction_message3.save.should be_true
      end

      it "should show a new message for an auction" do
        @auction_message = AuctionMessage.make!(:message => "Test Auction Message", :silent_auction_id => @running_auction.id, :creator => 'dummy_creator')
        @running_auction.auction_messages should_not be_nil
        @running_auction.auction_messages.should include @auction_message
      end
    end
  end
end
