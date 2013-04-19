require 'spec_helper'

describe "AuctionMessages" do
  describe "GET /auction_messages" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get new_silent_auction_auction_message_path
      response.status.should be(200)
    end
  end
end
