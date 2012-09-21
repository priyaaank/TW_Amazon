require 'spec_helper'

describe SilentAuctionsController do

  describe "GET 'index'" do

    describe "for non-signed-in users" do
      it 'should redirect to login page' do
        get :index
        redirect_to_login
      end
    end

    describe "for signed-in users" do
      before(:each) do
        @user = User.make!(:user)
        sign_in @user
        @user.region = "AUS"
        @user.save!
      end

      it 'should not open the index page when the user has not selected a region' do
        @user.region = nil
        @user.save!
        get :index
        response.should_not be_success
        @user.region = ""
        @user.save!
        get :index
        response.should_not be_success
      end
      
      it 'should return http success' do
        get :index
        response.should be_success
      end

      it 'should render the index template' do
        get :index
        response.should render_template 'index'
      end

      describe 'list all running auctions' do
        before(:each) do
          @auction1 = SilentAuction.make!(:created_at => 1.day.ago, :start_date => Time.now, :end_date => 7.days.from_now)
          @auction2 = SilentAuction.make!(:created_at => Time.now)
          @auction3 = SilentAuction.make!(:created_at => 1.minute.from_now)
          @close_auction = SilentAuction.make!(:open => false)
          get :index
        end

        it 'should assign the running auctions to the view' do
          assigns[:running_auctions].should include @auction1
          assigns[:running_auctions].should include @auction2
          assigns[:running_auctions].should include @auction3
          assigns[:running_auctions].should_not include @close_auction
          assigns[:running_auctions].count.should == 3
        end

        it 'should order running auctions by most recent first' do
          assigns[:running_auctions][0].should eql @auction3
          assigns[:running_auctions][1].should eql @auction2
          assigns[:running_auctions][2].should eql @auction1
        end
      end
    end
  end

  describe "GET 'closed'" do

    describe "for non-signed-in users" do
      it 'should redirect to login page' do
        get :closed
        redirect_to_login
      end
    end

    describe "for signed-in users" do
      before(:each) do
        @user = User.make!(:user)
        sign_in @user
        @user.region = "AUS"
        @user.save!
      end

      it 'should return http success' do
        get :closed
        response.should be_success
      end

      it 'should render the index template' do
        get :closed
        response.should render_template 'closed'
      end

      describe 'list all closed auctions that has at least one bid' do
        before(:each) do
          @auction1 = SilentAuction.make!(:created_at => Time.now + 100)
          @auction2 = SilentAuction.make!(:created_at => Time.now)
          @auction3 = SilentAuction.make!(:created_at => Time.now + 50)

          @user.bids.create(:silent_auction_id => @auction1.id, :amount => 100)
          @user.bids.create(:silent_auction_id => @auction2.id, :amount => 100)
          @user.bids.create(:silent_auction_id => @auction3.id, :amount => 100)

          @auction1.change_to_closed
          @auction2.change_to_closed
          @auction3.change_to_closed

          @run_auction = SilentAuction.make!
          @no_bid_auction = SilentAuction.make!(:open => false)
          get :closed
        end

        it 'should assign the closed auctions to the view' do
          assigns[:closed_auctions].should include @auction1
          assigns[:closed_auctions].should include @auction2
          assigns[:closed_auctions].should include @auction3
          assigns[:closed_auctions].should_not include @run_auction
          assigns[:closed_auctions].should_not include @no_bid_auction
          assigns[:closed_auctions].count.should == 3
        end

        it 'should order auctions by most recent first' do
          assigns[:closed_auctions][0].should eql @auction1
          assigns[:closed_auctions][1].should eql @auction3
          assigns[:closed_auctions][2].should eql @auction2
        end
      end
    end
  end

  describe "GET 'expired'" do

    describe "for unauthorized users" do
      it 'should redirect to login page if not sign-in' do
        get :expired
        redirect_to_login
      end

      it 'should not display the page, redirect back with "unauthorized" error message if user is not admin' do
        sign_in User.make!(:user)
        get :expired
        flash[:error].should include("Unauthorized Access")
        response.should redirect_to(index_path)
      end
    end

    describe "for sign-in admin" do
      before(:each) do
        @admin = User.make!(:admin)
        sign_in @admin
        @admin.region = "AUS"
        @admin.save!
      end

      it 'should return http success' do
        get :expired
        response.should be_success
      end

      it 'should render the index template' do
        get :expired
        response.should render_template 'expired'
      end

      describe 'list all expired auctions (closed auctions with no bid)' do
        before(:each) do
          @auction1 = SilentAuction.make!(:open => false, :created_at => Time.now + 100)
          @auction2 = SilentAuction.make!(:open => false, :created_at => Time.now)
          @auction3 = SilentAuction.make!(:open => false, :created_at => Time.now + 50)

          @run_auction = SilentAuction.make!

          @closed_auction = SilentAuction.make!()
          User.make!(:user).bids.create(:silent_auction_id => @closed_auction.id, :amount => 100)
          @closed_auction.change_to_closed

          get :expired
        end

        it 'should assign the closed auctions to the view' do
          assigns[:expired_auctions].should include @auction1
          assigns[:expired_auctions].should include @auction2
          assigns[:expired_auctions].should include @auction3
          assigns[:expired_auctions].should_not include @run_auction
          assigns[:expired_auctions].should_not include @closed_auction
          assigns[:expired_auctions].count.should == 3
        end

        it 'should order auctions by most recent first' do
          assigns[:expired_auctions][0].should eql @auction1
          assigns[:expired_auctions][1].should eql @auction3
          assigns[:expired_auctions][2].should eql @auction2
        end
      end
    end
  end

  describe "GET 'future'" do

    describe "for unauthorized users" do
      it 'should redirect to login page if not sign-in' do
        get :future
        redirect_to_login
      end

      it 'should not display the page, redirect back with "unauthorized" error message if user is not admin' do
        sign_in User.make!(:user)
        get :future
        flash[:error].should include("Unauthorized Access")
        response.should redirect_to(index_path)
      end
    end

    describe "for sign-in admin" do
      before(:each) do
        @admin = User.make!(:admin)
        sign_in @admin
        @admin.region = "AUS"
        @admin.save!
      end

      it 'should return http success' do
        get :future
        response.should be_success
      end

      it 'should render the index template' do
        get :future
        response.should render_template 'future'
      end

      describe 'list all future auctions' do
        before(:each) do
          @future = SilentAuction.make!(:start_date => Date.today + 1.day)

          @today = SilentAuction.make!(:start_date => Date.today)

          get :future
        end

        it 'should assign the closed auctions to the view' do
          assigns[:future_auctions].should include @future
          assigns[:future_auctions].should_not include @today
          assigns[:future_auctions].count.should == 1
        end

      end
    end
  end

  describe "GET 'new'" do

    describe "for signed-in Admin users" do

      before(:each) do
        @admin = User.make!(:admin)
        sign_in @admin
      end

      it 'should create a new unsaved silent auction with one placeholder photo' do
        get :new
        assigns[:silent_auction].should_not be_nil
        # need to test that one place holder photo is built
      end

      it 'should return http success' do
        get :new
        response.should be_success
      end
    end

    describe "for signed-in non-Admin users" do

      before(:each) do
        @user = User.make!(:user)
        sign_in @user
      end

      it 'should not display the page, redirect back with "unauthorized" error message' do
        get :new
        flash[:error].should include("Unauthorized Access")
        response.should redirect_to(index_path)
      end
    end

    describe "for non-signed-in users" do
      it 'should redirect to login page' do
        get :new
        redirect_to_login
      end
    end
  end

  describe "POST, 'create'" do

    before(:each) do
      # login an admin
      @admin = User.make!(:admin)
      sign_in @admin
    end

    context 'given valid auction details' do

      before(:each) do
        @valid_details = { :title => 'a', :description => 'b', :min_price => 250, :photos_attributes => {}, :start_date=>Date.today, :end_date=>7.days.from_now}
      end

      it 'should save new silent auction' do
        lambda do
          post :create, :silent_auction => @valid_details
        end.should change(SilentAuction, :count).by(1)
      end

      it 'should display confirmation message with auction title on successful save' do
        post :create,  :silent_auction => @valid_details
        flash[:success].should include(@valid_details[:title])
      end

      it 'should redirect to #new form if select "Save and create another"' do
        post :create, :silent_auction => @valid_details, :continue => true
        response.should redirect_to(new_silent_auction_path)
      end

      it 'should redirect to listing page if select "Save and return to listing"'  do
        post :create, :silent_auction => @valid_details, :done => true
        response.should redirect_to(silent_auctions_path)
      end
    end

    context 'given invalid auction details' do

      before(:each) do
        @invalid_details = { :title => '', :description => 'b', :min_price => 250, :photos_attributes => {}}
      end

      it 'should not create a new silent auction' do
        lambda do
          post :create, :silent_auction => @invalid_details
        end.should_not change(SilentAuction, :count)
      end

      it "should re-render the 'new' page" do
        post :create, :silent_auction => @invalid_details
        response.should render_template('new')
      end

    end
  end

  describe "PUT 'close'" do
    before (:each) do
      @admin = User.make!(:admin)
      sign_in @admin

      @auction = SilentAuction.make!
    end

    it 'should not close auction with no active bid' do
      put :close, :id => @auction.id
      SilentAuction.find(@auction.id).open.should == true

      # TEST RENDER CLOSE FAIL PARTIALS
    end

    it 'should close auction with at least one active bid' do
      user1 = User.make!(:user)
      user1.bids.create(:amount => 100, :silent_auction_id => @auction.id)
      put :close, :id => @auction.id
      SilentAuction.find(@auction.id).open.should == false

      # TEST RENDER CLOSE_AUCTION PARTIALS
    end

    it 'should not close auction with only withdrawn bids' do
      user1 = User.make!(:user)
      user1.bids.create(:amount => 100, :silent_auction_id => @auction.id, :active => false)

      user2 = User.make!(:user)
      user2.bids.create(:amount => 200, :silent_auction_id => @auction.id, :active => false)

      put :close, :id => @auction.id
      SilentAuction.find(@auction.id).open.should == true

      # TEST RENDER CLOSE FAIL PARTIALS
    end
  end

  describe "POST 'confirm_delete'" do

    before(:each) do
      @auction = SilentAuction.make!
    end

    describe "for signed-in admin users" do
      before (:each) do
        @admin = User.make!(:admin)
        sign_in @admin
      end

      it 'should return http success' do
        post :confirm_delete, :id => @auction.id
        response.should be_success
      end

      it 'should render the confirm delete template' do
        post :confirm_delete, :id => @auction.id
        response.should render_template 'confirm_delete'
      end

      it 'should assign the auction to display its info' do
        post :confirm_delete, :id => @auction.id
        assigns[:delete_auction].should eql @auction
      end

      describe 'list auction bidders' do
        before (:each) do
          @user_b = User.make!(:username => "b")
          @user_c = User.make!(:username => "c")
          @user_a = User.make!(:username => "a")

          @user_a.bids.create(:silent_auction_id => @auction.id, :amount => 100)
          @user_b.bids.create(:silent_auction_id => @auction.id, :amount => 200)
          @user_c.bids.create(:silent_auction_id => @auction.id, :amount => 300)

          @user_d = User.make!(:username => "d")
          withdraw_bid = @user_d.bids.create(:silent_auction_id => @auction.id, :amount => 800)
          withdraw_bid.withdraw
        end

        it 'should list all active bidders of the auction' do
          post :confirm_delete, :id => @auction.id
          assigns[:bidders].should include @user_a
          assigns[:bidders].should include @user_b
          assigns[:bidders].should include @user_c
          assigns[:bidders].should_not include @user_d
        end

        it 'should list active bidders by username ASC' do
          post :confirm_delete, :id => @auction.id
          assigns[:bidders][0].should eql @user_a
          assigns[:bidders][1].should eql @user_b
          assigns[:bidders][2].should eql @user_c
        end
      end
    end

    describe "for signed-in non-admin users" do
      before (:each) do
        @user = User.make!(:user)
        sign_in @user
      end

      it 'should not display the page, redirect back with "unauthorized" error message' do
        post :confirm_delete, :id => @auction.id
        flash[:error].should include("Unauthorized Access")
        response.should redirect_to(index_path)
      end
    end

    describe "for non-signed-in users" do
      it 'should redirect to login page' do
        post :confirm_delete, :id => @auction.id
        if Rails.application.config.test_mode
          response.should redirect_to(root_path)
        else
          response.should redirect_to(user_omniauth_authorize_path(:cas))
        end
      end
    end
  end

  describe "DELETE 'destroy'" do
    before(:each) do
      @auction = SilentAuction.make!
    end

    describe "for signed-in admin users" do
      before (:each) do
        @admin = User.make!(:admin)
        sign_in @admin
      end

      it 'should delete the auction' do
        lambda do
          delete :destroy, :id => @auction.id
        end.should change(SilentAuction, :count).by(-1)
      end

      it 'should delete auction and any associated bids of the auctions' do
        bid1 = User.make!.bids.create(:silent_auction_id => @auction.id, :amount => 100, :active => false)
        bid2 = User.make!.bids.create(:silent_auction_id => @auction.id, :amount => 200)
        bid3 = User.make!.bids.create(:silent_auction_id => @auction.id, :amount => 300)
        bid4 = User.make!.bids.create(:silent_auction_id => @auction.id, :amount => 400, :active => false)

        lambda do
          delete :destroy, :id => @auction.id
        end.should change(Bid, :count).by(-4)
      end

      it 'should go back to listing after delete, with success message' do
        delete :destroy, :id => @auction.id
        flash[:notice].should include @auction.title
        response.should redirect_to silent_auctions_path
      end
    end

    describe "for signed-in non-admin users" do
      before (:each) do
        @user = User.make!(:user)
        sign_in @user
      end

      it 'should not display the page, redirect back with "unauthorized" error message' do
        delete :destroy, :id => @auction.id
        flash[:error].should include("Unauthorized Access")
        response.should redirect_to(index_path)
      end
    end

    describe "for non-signed-in users" do
      it 'should redirect to login page' do
        delete :destroy, :id => @auction.id
        redirect_to_login
      end
    end
  end
end

