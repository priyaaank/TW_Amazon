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
        format.html {
          @silent_auction.errors[:min_price].each do |msg|
            msg.insert(0, "Minimum price ")
          end
          render :action => 'new'
        }
      end
    end
  end

  # PUT to close auction
  def close
    @silent_auction = SilentAuction.find(params[:id])
    respond_to do |format|
      if @silent_auction.close
        format.html { redirect_to silent_auction_path, :notice => "Auction for <b>#{@silent_auction.title}</b> has been closed".html_safe }
        format.js { render 'close_auction.js.erb'}
      else
        err_msg = @silent_auction.errors.full_messages
        format.html { redirect_to silent_auction_path, :notice => err_msg }
        format.js { render 'fail_close_auction.js.erb', :locals => { :errMsg => err_msg } }
      end
    end
  end

  # POST to ask for confirmation of deleting an auction
  def confirm_delete
    @title = "Confirm delete auction"
    @delete_auction = SilentAuction.find(params[:id])
    @bidders = User.joins(:bids).where(:bids => {:silent_auction_id => @delete_auction.id, :active => true}).order("username ASC")
    respond_to do |format|
      format.html
    end
  end

  # DELETE auction
  def destroy
    @auction = SilentAuction.find(params[:id])
    title = @auction.title
    @auction.destroy
    flash[:success] = "Auction <strong>#{title}</strong> has been successfully deleted.".html_safe
    redirect_to silent_auctions_path
  end
end
