class AuctionMessagesController < ApplicationController
  def show
  end
  def view_auction_details
    @silent_auction = SilentAuction.find(params[:id])
  end
end
