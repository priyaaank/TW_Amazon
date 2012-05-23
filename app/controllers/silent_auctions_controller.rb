class SilentAuctionsController < ApplicationController
  include ApplicationHelper

  before_filter :authenticate_user!
  before_filter :authorize_admin, :except => [:index, :closed]

  # GET /silent_auctions/running
  def index
    @title = "Running Auctions Listing"
    @running_auctions = SilentAuction.running.recent.includes(:bids)

    respond_to do |format|
      format.html
    end
  end

  # GET /silent_auctions/closed
  def closed
    @title = "Closed Auctions Listing"
    @closed_auctions = SilentAuction.closed.recent.page(params[:page])

    respond_to do |format|
      format.html
    end
  end

  # GET /silent_auctions/expired
  def expired
    @title = "Expired Auctions Listing"
    @expired_auctions = SilentAuction.expired.recent.page(params[:page])

    respond_to do |format|
      format.html
    end
  end

  # GET /silent_auctions/new
  # An HTTP GET to /resources/new is intended to render a form suitable for creating a new resource,
  # which it does by calling the new action within the controller,
  # which creates a new unsaved record and renders the form.

  def new
    @title = "Create new auction"
    @silent_auction = SilentAuction.new
    @silent_auction.photos.build
    respond_to do |format|
      format.html
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
          # to force error message for minimum price has a subject
          @silent_auction.errors[:min_price].each do |msg|
            msg.insert(0, "Minimum price ")
          end
          @title = "Create New Auction"
          @silent_auction.photos.build if @silent_auction.photos.empty?
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
        format.js { render 'close_auction'}
      else
        err_msg = @silent_auction.errors.full_messages
        format.html { redirect_to silent_auction_path, :notice => err_msg }
        format.js { render 'fail_close_auction', :locals => { :errMsg => err_msg } }
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

  # Edit Auction
  # only allow edit running auction that has no bid
  def edit
    @title = "Edit Auction"
    @silent_auction = SilentAuction.find(params[:id])
    @silent_auction.photos.build if @silent_auction.photos.empty?
    unless @silent_auction.open
      redirect_back_with_error(index_path,"You cannot edit closed auctions")
    else
      redirect_back_with_error(index_path,"You cannot edit auctions that have active bids") if @silent_auction.has_active_bid
    end
  end

  # Update Auction
  def update
    @silent_auction = SilentAuction.find(params[:id])
    respond_to do |format|
      if @silent_auction.update_attributes(params[:silent_auction])
        format.html {
          flash[:success] = "Auction <b>#{@silent_auction.title}</b> was successfully updated!".html_safe
          redirect_to silent_auctions_path
        }
      else
        format.html {
          # to force error message for minimum price has a subject
          @silent_auction.errors[:min_price].each do |msg|
            msg.insert(0, "Minimum price ")
          end
          @title = "Create New Auction"
          @silent_auction.photos.build if @silent_auction.photos.empty?
          render :action => 'edit'
        }
      end
    end
  end
end
