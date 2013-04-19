class AuctionMessagesController < ApplicationController
  include ApplicationHelper
  before_filter :authenticate_user!

  def new
    @silent_auction = SilentAuction.find(params[:silent_auction_id])
    @auction_message = AuctionMessage.new
    @auction_messages = AuctionMessage.find_all_by_silent_auction_id(@silent_auction.id)
  end
  def create
    @auction_message = AuctionMessage.new(params[:auction_message])
    @auction_message.creator = current_user.username
    @silent_auction = SilentAuction.find(params[:silent_auction_id])
    @auction_messages = AuctionMessage.find_all_by_silent_auction_id(@silent_auction.id)
    respond_to do |format|
      if @auction_message.save
        flash[:success] = "New Message was successfully created!".html_safe
        format.html { redirect_to new_silent_auction_auction_message_path }
      else
        format.html{
          @title = "Create Auction Messages"
          render :action => 'new'
        }
      end
    end
  end
end
