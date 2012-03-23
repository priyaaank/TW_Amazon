class SilentAuctionsController < ApplicationController

  # GET /silent_auctions/new
  def new
    @silent_auction = SilentAuction.new
  end

  # POST /silent_auctions
  def create
    @silent_auction = SilentAuction.new(params[:silent_auction])
    if @silent_auction.save
      flash[:notice] = 'SilentAuction was successfully created'
    end
    render action: "new"
  end

end
