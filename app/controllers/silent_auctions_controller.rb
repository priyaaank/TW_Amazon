class SilentAuctionsController < ApplicationController

  # GET /silent_auctions
  def index
    @silent_auctions = SilentAuction.all

    respond_to do |format|
      format.html # index.html.haml
    end
  end

  # GET /silent_auctions/new
  def new
    @silent_auction = SilentAuction.new

    respond_to do |format|
      format.html # new.html.haml
    end
  end

  # POST /silent_auctions
  def create
    @silent_auction = SilentAuction.new(params[:silent_auction])

    respond_to do |format|
      if @silent_auction.save
        format.html { redirect_to silent_auctions_path, notice: 'New silent auction was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

end
