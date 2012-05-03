require 'spec_helper'

describe Bid do

  describe "to be valid" do

    before(:each) do
      @auction = SilentAuction.make!
      @user = User.make!(:user)
    end

    it 'should have an amount' do
      bid = @user.bids.new(:silent_auction_id => @auction.id)
      bid.should_not be_valid
      bid.amount = 250
      bid.should be_valid
    end

    it 'should default to active' do
      bid = @user.bids.new(:silent_auction_id => @auction.id, :amount => 250)
      bid.active.should == true
    end

    it 'should not allow bid amount negative or zero' do
      bid = @user.bids.new(:silent_auction_id => @auction.id, :amount => -999)
      bid.should_not be_valid
      bid.amount = 0
      bid.should_not be_valid
      bid.amount = 100
      bid.should be_valid
    end

    it 'should not allow bid amount more than 9999.99' do
      bid = @user.bids.new(:silent_auction_id => @auction.id, :amount => 450000)
      bid.should_not be_valid
      bid.amount = 9999.99
      bid.should be_valid
    end

    it 'should only allow bid amount with 2 decimal places' do
      bid = @user.bids.new(:silent_auction_id => @auction.id, :amount => 33.555)
      bid.should_not be_valid
      bid.amount = 100.99
      bid.should be_valid
    end
  end

end
