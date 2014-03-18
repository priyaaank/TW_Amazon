require 'spec_helper'

describe AuctionMessagesController do
  include Devise::TestHelpers
  describe "POST 'create'" do

    before(:each) do
      @user = User.make!(:user, :region => Region.make!(:aus))
      sign_in @user
    end

    context 'given a running auction' do
      before (:each) do
        @running_auction = SilentAuction.make!
      end

     it 'should not have any messages when an empty message is added to an auction' do
        lambda {
          post :create, {auction_message: {message: ''}, silent_auction_id: @running_auction}
        }.should_not change(@running_auction.auction_messages, :count)
      end
    end
  end
end
