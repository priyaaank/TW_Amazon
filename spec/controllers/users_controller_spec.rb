require 'spec_helper'

describe UsersController do
  include Devise::TestHelpers

  describe "GET 'show'" do

    describe "for non-signed-in users" do
      it 'should redirect to login page' do
        get :show
        if Rails.application.config.test_mode
          response.should redirect_to(root_path)
        else
          response.should redirect_to(user_omniauth_authorize_path(:cas))
        end
      end
    end

    describe "for signed-in non-admin users" do
      before(:each) do
        @user = User.make!(:user)
        sign_in @user
      end

      it "should return http success" do
        get :show, :id => @user.id
        response.should be_success
      end

      it 'should allow a user to see only their profile page' do
        wrong_user = User.create(username: 'wrong-user', password: 'barfoo')
        get :show, :id => wrong_user.id
        response.should redirect_to(root_path)
      end

      describe 'listing auctions user has placed bid on' do
        before(:each) do
          auction1 = SilentAuction.make!
          auction2 = SilentAuction.make!
          auction3 = SilentAuction.make!
          auction4 = SilentAuction.make!

          @bid1 = @user.bids.create(:silent_auction_id => auction1.id, :amount => 100)
          @bid2 = @user.bids.create(:silent_auction_id => auction2.id, :amount => 200)
          @bid3 = @user.bids.create(:silent_auction_id => auction3.id, :amount => 200)
          @bid4 = @user.bids.create(:silent_auction_id => auction4.id, :amount => 200)

          auction2.change_to_closed
          auction4.change_to_closed

          get :show, :id => @user.id
        end

        it 'should list all running auctions that user placed bid on' do
          assigns[:running_bids].should include @bid1
          assigns[:running_bids].should include @bid3
          assigns[:running_bids].should_not include @bid2
          assigns[:running_bids].should_not include @bid4
        end

        it 'should list all closed auctions that user placed bid on' do
          assigns[:closed_bids].should_not include @bid1
          assigns[:closed_bids].should_not include @bid3
          assigns[:closed_bids].should include @bid2
          assigns[:closed_bids].should include @bid4
        end
      end
    end
  end
end
