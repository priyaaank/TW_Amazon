require 'spec_helper'

describe SilentAuctionsController do
  render_views

  describe "GET 'index'" do
    it 'should return http success' do
      get :index
      response.should be_success
    end

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

    it 'should have a title field' do
      get :new
      response.body.should have_selector("input", :type => 'text', :name => "silent_auction['title']")
    end

    it 'should have a description textarea' do
      get :new
      response.body.should have_selector("textarea", :name => "silent_auction['description']")
    end

    #it 'should have a "Save and continue" button' do
    #  get :new
    #  response.body.should have_selector("input", :type => 'submit', :name => 'continue')
    #end
    #
    #it 'should have a "Save and return" button' do
    #  get :new
    #  response.body.should have_selector("input", :type => 'submit', :name => 'done')
    #end

  end

  describe "POST, 'create'" do

    before(:each) do
      @mock_auction = mock_model(SilentAuction, :title => 'a', :description => 'b').as_new_record
      SilentAuction.stub!(:new).and_return @mock_auction
    end

    context 'given valid auction details' do

      before(:each) do
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
        @mock_auction.stub!(:title).and_return('')
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

    #describe 'create new auction process' do
    #
    #  describe 'failure' do
    #    it 'should not create a new silent auction' do
    #      lambda do
    #        visit new_silent_auction_path
    #        fill_in "title", :with => ""
    #        fill_in "description", :with => ""
    #        click_button 'continue'
    #        response.should render_template('silent_auctions/new')
    #      end.should_not change(SilentAuction, :count)
    #    end
    #  end
    #
    #  describe 'success' do
    #    it 'should create a new silent auction' do
    #      lambda do
    #        visit new_silent_auction_path
    #        fill_in "title", :with => "title"
    #        fill_in "description", :with => "description"
    #        click_button 'continue'
    #        response.should render_template('silent_auctions/new')
    #      end.should change(SilentAuction, :count).by[1]
    #    end
    #  end
    #
    #end
end

