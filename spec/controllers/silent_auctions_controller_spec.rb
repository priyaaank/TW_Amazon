require 'spec_helper'

describe SilentAuctionsController do

  describe "GET new" do
    it 'should create a new unsaved silent auction' do
      SilentAuction.should_receive(:new).and_return(@silent_auction)
      get :new
    end

    it 'returns http success' do
      get :new
      response.should be_success
    end
  end

  describe "POST create" do
    before do
      @mock_auction = mock('SilentAuction')
      SilentAuction.should_receive(:new).and_return(@mock_auction)
    end

    context 'given valid auction details' do
      it 'creates a new silent auction' do
        @mock_auction.should_receive(:save).and_return(true)
        post :create, :silent_auction => {:title => 'a', :description => 'b'}
        #flash[:notice].should_not be_nil
      end

      it 'displays confirmation message with auction title on successful save'

      it 're-render #new form if select "Save and create another"'

      it 'redirect to listing page if select "Save and return to listing"'
    end

    context 'given invalid auction details' do
      it 'not create a new silent auction and re-render #new form' do
        @mock_auction.should_receive(:save).and_return(false)
        post :create, :silent_auction => {:title => '', :description => 'b'}
      end
    end

  end

end

