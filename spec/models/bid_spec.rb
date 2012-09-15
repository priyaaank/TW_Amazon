require 'spec_helper'

describe Bid do
  describe "to be valid" do

    before(:each) do
      @auction = SilentAuction.make!
      @user = User.make!(:user)
    end

    it 'should default to active' do
      bid = @user.bids.new(:silent_auction_id => @auction.id, :amount => 250)
      bid.should be_valid
      bid.active.should == true
    end

    it 'should have an amount' do
      bid = @user.bids.new(:silent_auction_id => @auction.id)
      bid.should_not be_valid
      bid.should have_at_least(1).errors_on(:amount)
      bid.amount = 250
      bid.should be_valid
    end

    it 'should not allow invalid number for amount' do
      bid = @user.bids.new(:silent_auction_id => @auction.id)
      bid.amount = "abcd"
      bid.should_not be_valid
      bid.amount = "45   55"
      bid.should_not be_valid
      bid.amount = "$343"
      bid.should_not be_valid
      bid.amount = "$343.123"
      bid.should_not be_valid
      bid.amount = "$^%&%"
      bid.should_not be_valid
    end

    it 'should not allow bid amount negative or zero' do
      bid = @user.bids.new(:silent_auction_id => @auction.id, :amount => -999)
      bid.should_not be_valid
      bid.should have_at_least(1).errors_on(:amount)
      bid.amount = 0
      bid.should_not be_valid
      bid.should have_at_least(1).errors_on(:amount)
      bid.amount = 100
      bid.should be_valid
    end
=begin
    it 'should not allow bid amount more than 9999.99' do
      bid = @user.bids.new(:silent_auction_id => @auction.id, :amount => 450000)
      bid.should_not be_valid
      bid.should have_at_least(1).errors_on(:amount)
      bid.amount = 9999.99
      bid.should be_valid
    end
=end
    it 'should only allow bid amount with 2 decimal places' do
      bid = @user.bids.new(:silent_auction_id => @auction.id, :amount => 33.555)
      bid.should_not be_valid
      bid.should have_at_least(1).errors_on(:amount)
      bid.amount = 100.99
      bid.should be_valid
    end

    it 'should not be placed for a closed auction' do
      @auction.open = false
      @auction.save
      bid = @user.bids.new(:silent_auction_id => @auction.id, :amount => 100)
      bid.should_not be_valid
      bid.should have_at_least(1).errors_on(:silent_auction_id)
    end

    it 'should not be placed if user already bid on the auction' do
      @user.bids.create(:silent_auction_id => @auction.id, :amount => 100)
      new_bid = @user.bids.new(:silent_auction_id => @auction.id, :amount => 200)
      new_bid.should_not be_valid
      new_bid.should have_at_least(1).errors_on(:silent_auction_id)
    end

    it 'should not allow amount that less than auction minimum price' do
      auction1 = SilentAuction.make!(:min_price => 250)
      bid = @user.bids.new(:silent_auction_id => auction1.id)
      bid.amount = 100
      bid.valid?.should == false
      bid.amount = 250.00
      bid.valid?.should == true
    end
  end

  describe 'withdraw' do

    before(:each) do
      @auction = SilentAuction.make!
      @current_user = User.make!(:user)
      @bid = @current_user.bids.create(:silent_auction_id => @auction.id, :amount => 100)
    end

    it 'should become inactive if auction is open' do
      @bid.withdraw
      @bid.active.should == false
    end

    it 'should not become inactive if auction is closed' do
      @auction.change_to_closed
      @bid.withdraw
      @bid.active.should_not == false
      @bid.should have_at_least(1).errors
    end
  end
end
