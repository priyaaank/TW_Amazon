require 'spec_helper'

describe SilentAuctionsController do
  #render_views

  describe "GET 'index'" do
    it 'should return http success' do
      get :index
      response.should be_success
    end

    it 'should list all auctions'

    it 'should order auctions by created date, with recent ones first'

  end

  describe "GET 'new'" do
    it 'should create a new unsaved silent auction' do
      SilentAuction.should_receive(:new).and_return(@silent_auction)
      get :new
    end

    it 'should return http success' do
      get :new
      response.should be_success
    end

  end

  describe "POST 'create'" do

    before(:each) do
      @mock_auction = mock('SilentAuction')
      SilentAuction.should_receive(:new).and_return(@mock_auction)
      #@invalidAttr = {:title => '', :description => ''}
      #@validAttr = {:title => 'a', :description => 'b'}
    end

    context 'given valid auction details' do

      it 'should create a new silent auction' do
        @mock_auction.should_receive(:save).and_return(true)
        post :create, :silent_auction => {:title => 'a', :description => 'b'}
      end

      it 'should display confirmation message with auction title on successful save' do
        post :create, :silent_auction => @validAttr
        flash[:success].should include? @mock_auction.title
      end

      it 'should redirect to #new form if select "Save and create another"' do
        post :create, :silent_auction => @validAttr.merge(:continue => true)
        response.should redirect_to(new_silent_auction_path)
      end

      it 'should redirect to listing page if select "Save and return to listing"'  do
        post :create, :silent_auction => @validAttr.merge(:done => true)
        response.should redirect_to(silent_auctions_path)
      end

    end

    context 'given invalid auction details' do

      it 'should not create a new silent auction' do
        @mock_auction.should_receive(:save).and_return(false)
        post :create, :silent_auction => @invalidAttr
      end

      it "should re-render the 'new' page" do
        post :create, :silent_auction => @invalidAttr
        response.should render_template('new')
      end

    end

  end

end

