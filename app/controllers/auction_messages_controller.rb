class AuctionMessagesController < ApplicationController
  include ApplicationHelper
  before_filter :authenticate_user!

  def new
    @title = 'Auction Details'
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
         if @silent_auction.creator == @auction_message.creator
            UserMailer.send_announcement_from_creator_auction_message(@silent_auction)
         else
            UserMailer.send_announcement_from_other_users_auction_message(@silent_auction)
            UserMailer.send_announcement_to_creator_auction_message(current_user.id,current_user.username,@silent_auction.title)
         end
      else
        format.html{
          @title = "Create Auction Messages"
          render :action => 'new'
        }
      end
    end
  end
end
