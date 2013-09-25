require 'spec_helper'

describe BidsController do
  include Devise::TestHelpers

  describe "POST 'create'" do

    before(:each) do
      @user = User.make!(:user, :region => Region.make!(:aus))
      sign_in @user
    end

    context "given a running auction" do
      before :each do
        @running_auction = SilentAuction.make!(:silent_auction, :creator => @user.username)
      end

      it 'should create a new bid given valid details and user has not placed bid on the auction before' do
        lambda {
          post :create, :bid => {:amount => 100, :silent_auction_id => @running_auction.id}
        }.should change(@running_auction.bids, :count).by(1)
      end

      it 'should not create new bid if user has placed bid for the auction' do
        @user.bids.create(:amount => 300, :silent_auction_id => @running_auction.id)
        lambda {
          post :create, :bid => {:amount => 100, :silent_auction_id => @running_auction.id}
        }.should_not change(@running_auction.bids, :count)
      end

      it 'should not create bid given invalid details' do
        lambda {
          post :create, :bid => {:amount => -99, :silent_auction_id => @running_auction.id}
        }.should_not change(@running_auction.bids, :count)
      end

    end

    context "given a closed auction" do
      it 'should not create a new bid' do
        closed_auction = SilentAuction.make!(:open => false)
        lambda {
          post :create, :bid => {:amount => 100, :silent_auction_id => closed_auction.id}
        }.should_not change(closed_auction.bids, :count)
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

    context 'given a running auction' do

      it 'should withdraw the bid' do
        put :withdraw, :id => @bid.id
        Bid.find(@bid.id).active.should be_false
      end

      it 'should not allow anyone other than bid owner to withdraw the bid' do
        other_user = User.make!(:user)
        other_user_bid = other_user.bids.create(:amount => 200, :silent_auction_id => @auction.id)
        put :withdraw, :id => other_user_bid.id
        Bid.find(other_user_bid.id).active.should_not be_false
        flash[:error].should include "Unauthorized Withdrawal"
      end

      #it 'should redirect to previous page with success message if javascript not enabled' do
      #  request.env['HTTP_REFERER'] = "http://test.host/previous/page"
      #  put :withdraw, :id => @bid.id
      #  #flash[:notice].should eql "Bid withdrawn successfully"
      #  response.should redirect_to :back
      #end
      #
      #it 'should render withdrawn bid view if javascript enabled' do
      #  put :withdraw, :id => @bid.id, :format => 'js'
      #  response.should render_template(:partial => 'withdraw_done.js.erb')
      #end
    end

    context 'given a closed auction' do
      before(:each) do
        @auction.close
      end

      it 'should not withdraw the bid if auction is closed' do
        put :withdraw, :id => @bid.id
        Bid.find(@bid.id).active.should_not be_false
      end

      #it 'should redirect to previous page with error message if javascript not enabled' do
      #  request.env['HTTP_REFERER'] = "http://test.host/previous/page"
      #  put :withdraw, :id => @bid.id
      #  flash[:alert].should eql @bid.errors.full_messages[0]
      #  response.should redirect_to :back
      #end
      #
      #it 'should render fail withdraw view if javascript enabled' do
      #  put :withdraw, :id => @bid.id, :format => 'js'
      #  response.should render_template(:partial => 'fail_withdraw.js.erb')
      #end
    end


  end
end
