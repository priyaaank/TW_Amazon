require 'spec_helper'

describe SilentAuctionsController do

  describe "GET 'index'" do

    describe "for non-signed-in users" do
      it 'should redirect to login page' do
        get :index
        if Rails.application.config.test_mode
          response.should redirect_to(root_path)
        else
          response.should redirect_to(user_omniauth_authorize_path(:cas))
        end
      end
    end

    describe "for signed-in users" do
      before(:each) do
        @user = User.make!(:user)
        sign_in @user
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
          @running_auction1 = mock_model(SilentAuction, :title => 'a', :description => 'b', :created_at => Time.now)
          @running_auction2 = mock_model(SilentAuction, :title => 'c', :description => 'd', :created_at => Time.now + 1)
          SilentAuction.stub_chain(:running, :recent, :includes).and_return([@running_auction2, @running_auction1])
          get :index
        end

        it 'should assign the running auctions to the view' do
          assigns[:running_auctions].include?(@running_auction1).should be_true
          assigns[:running_auctions].include?(@running_auction2).should be_true
        end


      end

      describe 'list all closed auctions' do
        before(:each) do
          @closed_auction1 = mock_model(SilentAuction, :title => 'a', :description => 'b', :open => false)
          @closed_auction2 = mock_model(SilentAuction, :title => 'c', :description => 'd', :open => false)
          SilentAuction.stub_chain(:closed, :recent, :includes).and_return([@closed_auction2, @closed_auction1])
          get :index
        end

        it 'should assign the closed auctions to the view' do
          assigns[:closed_auctions].should include(@closed_auction1)
          assigns[:closed_auctions].should include(@closed_auction2)
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

      it 'should create a new unsaved silent auction' do
        SilentAuction.should_receive(:new).and_return(@silent_auction)
        get :new
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
        if Rails.application.config.test_mode
          response.should redirect_to(root_path)
        else
          response.should redirect_to(user_omniauth_authorize_path(:cas))
        end
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
        @mock_auction = mock_model(SilentAuction, :title => 'a', :description => 'b').as_new_record
        SilentAuction.stub!(:new).and_return @mock_auction
        @mock_auction.stub!(:save).and_return(true)
      end

      it 'should save new silent auction' do
        post :create
        @mock_auction.save.should eql true
      end

      it 'should display confirmation message with auction title on successful save' do
        post :create
        flash[:success].should include(@mock_auction.title)
      end

      it 'should redirect to #new form if select "Save and create another"' do
        post :create, :continue => true
        response.should redirect_to(new_silent_auction_path)
      end

      it 'should redirect to listing page if select "Save and return to listing"'  do
        post :create, :done => true
        response.should redirect_to(silent_auctions_path)
      end

    end

    context 'given invalid auction details' do

      before(:each) do
        @mock_auction = mock_model(SilentAuction, :title => '', :description => 'b').as_new_record
        SilentAuction.stub!(:new).and_return @mock_auction
        @mock_auction.stub!(:save).and_return(false)
        post :create
      end

      it 'should not create a new silent auction' do
        @mock_auction.save.should eql false
      end

      it "should re-render the 'new' page" do
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
      flash[:error].should eql "Auction with no active bid cannot be closed"
      SilentAuction.find(@auction.id).open.should == true
      response.should redirect_to(silent_auction_path)
    end

    it 'should close auction with at least one active bid' do
      user1 = User.make!(:user)
      user1.bids.create(:amount => 100, :silent_auction_id => @auction.id)
      put :close, :id => @auction.id
      SilentAuction.find(@auction.id).open.should == false
    end

    it 'should not close auction with only withdrawn bids' do
      user1 = User.make!(:user)
      user1.bids.create(:amount => 100, :silent_auction_id => @auction.id, :active => false)

      user2 = User.make!(:user)
      user2.bids.create(:amount => 200, :silent_auction_id => @auction.id, :active => false)

      put :close, :id => @auction.id
      SilentAuction.find(@auction.id).open.should == true
    end

    it 'should render the close auction layout after succeed'

  end
end

