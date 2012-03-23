class SilentAuctionsController < ApplicationController

  # GET /silent_auctions
  def index
    #@silent_auctions = SilentAuction.all

    #respond_to do |format|
    #  format.html # index.html.haml
    #end
  end

  # GET /silent_auctions/new
  # An HTTP GET to /resources/new is intended to render a form suitable for creating a new resource,
  # which it does by calling the new action within the controller,
  # which creates a new unsaved record and renders the form.

  def new
    @silent_auction = SilentAuction.new

    #respond_to do |format|
    #  format.html # new.html.haml
    #end
  end

  # POST /silent_auctions
  # An HTTP POST to /resources takes the record created as part of the new action
  # and passes it to te create action within the controller which then attempts to save it to the database.

  def create
    @silent_auction = SilentAuction.new(params[:silent_auction])
    if @silent_auction.save
      flash[:notice] = 'SilentAuction was successfully created'
    end
    render action: "new"


    #respond_to do |format|
    #  if @silent_auction.save
    #    format.html { redirect_to silent_auctions_path, notice: 'New silent auction was successfully created.' }
    #  else
    #    format.html { render action: "new" }
    #  end
    #end
  end

end
