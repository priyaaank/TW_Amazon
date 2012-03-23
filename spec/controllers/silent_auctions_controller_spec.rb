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
    it 'should create a new silent auction and give notice on successful save' do
      post :create, :silent_auction => {"title" => 'a', "description" => 'b'}
      SilentAuction.should_receive(:save).and_return(true)
      flash[:notice].should_not be_nil
    end

    it 'should not create an invalid silent auction' do
      post :create, :silent_auction => {"title" => '', "description" => 'b'}
      SilentAuction.should_receive(:save).and_return(false)
      flash[:notice].should be_nil
    end
  end

end
