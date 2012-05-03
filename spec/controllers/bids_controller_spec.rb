require 'spec_helper'

describe BidsController do
  include Devise::TestHelpers

  describe "POST 'create'" do

    before(:each) do
      @user = User.make!(:user)
      sign_in @user
    end

    context "given a running auction" do
      before (:each) do
        @running_auction = SilentAuction.make!
      end

      it 'should create a new bid if user has not placed bid on the auction before' do


      end

      it 'should not create new bid if user has placed bid for the auction'

    end

    context "given a closed auction" do

      it 'should not create a new bid'

      it 'should display error message'
    end

  end

  describe "PUT 'withdraw'" do
    before(:each) do
      @user = User.make!(:user)
      sign_in @user
    end

    context "given a running auction" do

      it 'should withdraw the bid' do
        auction = SilentAuction.make!
        bid = user.bids.create(:amount => 100, :silent_auction_id => auction.id)

        put :withdraw, :id => bid.id
        changed_bid = Bid.find(bid.id)

      end

    end

    context "given a closed auction" do

      it 'should not withdraw the bid'

      it 'should display error message'
    end

  end

end
