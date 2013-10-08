require 'spec_helper'

describe UsersController do
  include Devise::TestHelpers

  describe "GET 'show'" do

    describe "for signed-in non-admin users" do
      before(:each) do
        @region = Region.make!(:aus)
        @user = User.make!(:user, :region => @region)
        sign_in @user
      end

      it "should return http success" do
        get :show, :id => @user.id
        response.should be_success
      end

      it 'should allow a user to see only their profile page' do
        wrong_user = User.create(username: 'wrong-user', password: 'barfoo')
        get :show, :id => wrong_user.id
        flash[:error].should include("Unauthorized Access")
        response.should redirect_to(silent_auctions_path)
      end

      describe 'listing auctions user has placed bid on' do
        before(:each) do
          auction1 = SilentAuction.make! :region => @region
          auction2 = SilentAuction.make! :region => @region
          auction3 = SilentAuction.make! :region => @region
          auction4 = SilentAuction.make! :region => @region

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
