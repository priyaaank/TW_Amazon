class SilentAuctionsController < ApplicationController

  # GET /silent_auctions
  def index
    @running_auctions = SilentAuction.running.order("created_at DESC")
    @closed_auctions = SilentAuction.closed.order("created_at DESC")

    respond_to do |format|
      format.html # index.html.haml
    end
  end

  # GET /silent_auctions/new
  # An HTTP GET to /resources/new is intended to render a form suitable for creating a new resource,
  # which it does by calling the new action within the controller,
  # which creates a new unsaved record and renders the form.

  def new
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

end
