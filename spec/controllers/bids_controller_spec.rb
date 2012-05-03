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

      it 'should create a new bid given valid details and user has not placed bid on the auction before' do
        lamda {
          post :create, :bid => {:amount => 100, :silent_auction_id => @running_auction}
        }.should change(@running_auction.bids.count).by(1)
      end

      it 'should not create new bid if user has placed bid for the auction' do
        lamda {
          post :create, :bid => {:amount => 100, :silent_auction_id => @running_auction}
        }.should_not change(@running_auction.bids.count)
        flash[:error].should eql 'You have already bid on this auction'
      end

      it 'should not create bid given invalid details' do
        lamda {
          post :create, :bid => {:amount => -99, :silent_auction_id => @running_auction}
        }.should_not change(@running_auction.bids.count)
      end

    end

    context "given a closed auction" do

      it 'should not create a new bid' do
        closed_auction = SilentAuction.make!(:open => false)
        lamda {
          post :create, :bid => {:amount => -99, :silent_auction_id => closed_auction}
        }.should_not change(closed_auction.bids.count)
      end
    end

  end

  describe "PUT 'withdraw'" do
    before(:each) do
      @user = User.make!(:user)
      sign_in @user

      @auction = SilentAuction.make!
      @bid = @user.bids.create(:amount => 100, :silent_auction_id => @auction.id)
    end

    it 'should withdraw the bid if auction is still open' do
      put :withdraw, :id => bid.id

      Bid.find(@bid.id).active.should == false
      flash[:success].should eql "Bid withdrawn successfully"

      # NEED TO TEST RENDER JAVASCRIPT PARTIALS AND HTML REDIRECT AS WELL
    end

    it 'should not withdraw the bid if auction is closed' do
      @auction.open = false
      @auction.save

      put :withdraw, :id => @bid.id
      Bid.find(@bid.id).active.should == true
      flash[:error].should eql 'Error! Auction was closed! Bid cannot be withdrawn'

      # NEED TO TEST RENDER JAVASCRIPT PARTIALS AND HTML REDIRECT AS WELL
    end
  end
end
