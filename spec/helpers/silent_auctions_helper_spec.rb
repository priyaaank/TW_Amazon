require 'spec_helper'

describe SilentAuctionsHelper do
  include Devise::TestHelpers

  describe 'user_bid_for_auction' do
    it 'should return the bid current user place on the auction' do
      user = User.make!(:user)
      sign_in user

      auction = SilentAuction.make!
      bid = user.bids.create(:silent_auction_id => auction.id, :amount => 300)
      helper.user_bid_for_auction(auction).should eql bid
    end
  end

  describe 'won_bid_for_auction' do

    before (:each) do
      @auction = SilentAuction.make!
      user1 = User.make!(:user)
      user2 = User.make!(:user)
      user3 = User.make!(:user)

      @bid1 = user1.bids.create(:silent_auction_id => @auction.id, :amount => 300)
      @bid2 = user2.bids.create(:silent_auction_id => @auction.id, :amount => 500)
      @bid3 = user3.bids.create(:silent_auction_id => @auction.id, :amount => 255)
    end

    it 'should return the highest bid' do
      user = User.make!(:user)
      bid = user.bids.create(:silent_auction_id => @auction.id, :amount => 600)
      helper.won_bid_for_auction(@auction).should eql bid
    end

    it 'should return the earlier bid if two highest bids have same amount' do
      user = User.make!(:user)
      bid = user.bids.create(:silent_auction_id => @auction.id, :amount => 500)
      helper.won_bid_for_auction(@auction).should eql @bid2
    end

  end

end
