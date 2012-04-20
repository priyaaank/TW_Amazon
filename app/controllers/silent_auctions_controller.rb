class SilentAuctionsController < ApplicationController
  include ApplicationHelper

  before_filter :authenticate_user!
  before_filter :authorize_admin, :except => :index

  # GET /silent_auctions
  def index
    @title = "Silent Auctions Listing"
    @running_auctions = SilentAuction.running.recent.includes(:bids)
    @closed_auctions = SilentAuction.closed.recent.includes(:bids)

    respond_to do |format|
      format.js # ensure the controller can accept javascript call
      format.html # new.html.haml
    end
  end

  # GET /silent_auctions/new
  # An HTTP GET to /resources/new is intended to render a form suitable for creating a new resource,
  # which it does by calling the new action within the controller,
  # which creates a new unsaved record and renders the form.

  def new
    @title = "Create new auction"
    @silent_auction = SilentAuction.new
    respond_to do |format|
      format.html # new.html.haml
    end

  end

  # POST /silent_auctions
  # An HTTP POST to /resources takes the record created as part of the new action
  # and passes it to te create action within the controller which then attempts to save it to the database.

  def create
    @silent_auction = SilentAuction.new(params[:silent_auction])
    respond_to do |format|
      if @silent_auction.save
        flash[:success] = "New auction for <b>#{@silent_auction.title}</b> was successfully created!".html_safe

        if params['continue']
          format.html { redirect_to new_silent_auction_path }
        else if params['done']
              format.html {redirect_to silent_auctions_path}
             end
        end
      else
        format.html { render action: "new" }
      end
    end
  end

  # POST to close auction
  def close
    @silent_auction = SilentAuction.find(params['auction_id'])
    if @silent_auction.bids.empty?
      flash[:error] = "Auction with no bid cannot be closed"
    else
      @silent_auction.open = false
      flash[:success] = "Auction for <b>#{@silent_auction.title}</b> has been closed".html_safe
    end
  end
end
