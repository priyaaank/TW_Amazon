class SilentAuctionsController < ApplicationController
  include ApplicationHelper
  include SilentAuctionsHelper
  include UsersHelper

  before_filter :authenticate_user!
  before_filter :ensure_signed_in_user_has_a_region, :only => [:index, :closed, :expired, :future]

  # GET /silent_auctions/running
  def index
    @title = "Running Auctions Listing"
    if current_user.admin?
      @running_auctions = SilentAuction.running_auction_for_admin(get_region_config(current_user.region)["timezone"]).recent.includes(:bids)
    else
      @running_auctions = SilentAuction.running_auction_for_user(get_region_config(current_user.region)["timezone"],current_user.username).recent.includes(:bids)  
    end
  end

  # GET /silent_auctions/quick_sales
  def sales
    @title = "Quick Sales Board"
    if current_user.admin?
      @running_sales = SilentAuction.running_quick_sales_for_admin(get_region_config(current_user.region)["timezone"]).recent      
    else
      @running_sales = SilentAuction.running_quick_sales_for_user(get_region_config(current_user.region)["timezone"],current_user.username).recent      
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
    #@expired_auctions = SilentAuction.expired.recent.page(params[:page])
    @expired_auctions = SilentAuction.expired.order("end_date DESC").page(params[:page])

    respond_to do |format|
      format.html
    end
  end

  # GET /silent_auctions/future
  def future
    @title = "Future Auctions Listing"
    @future_auctions = SilentAuction.future(get_region_config(current_user.region)["timezone"]).recent.page(params[:page])

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
        flash[:success] = "New item for <b>#{@silent_auction.title}</b> was successfully created!".html_safe

        if params['continue']
          format.html { redirect_to new_silent_auction_path }
        else if params['done']
              if @silent_auction.item_type == 'Silent Auction'
                format.html {redirect_to list_my_items_user_path(current_user)}
              else
                format.html {redirect_to list_my_sales_user_path(current_user)}
              end
            end
        end
        unless Rails.application.config.test_mode
          if @silent_auction.start_date.to_date == Time.zone.now.in_time_zone(get_region_config(@silent_auction.region)["timezone"]).to_date
            UserMailer.send_announcement_to_other_users(@silent_auction).deliver
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
    redirect_back_with_success(index_path, "Item <strong>#{title}</strong> has been successfully deleted.".html_safe)
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
          if current_user.admin == true
            flash[:success] = "<b>#{@silent_auction.title}</b> was successfully updated!".html_safe
            if @silent_auction.item_type == 'Silent Auction'
              redirect_to silent_auctions_path
            else
              redirect_to sales_silent_auctions_path
            end
          else
            flash[:success] = "<b>#{@silent_auction.title}</b> was successfully updated!".html_safe
            #redirect_to sales_silent_auctions_path
            if @silent_auction.item_type == 'Silent Auction'
              redirect_to list_my_items_user_path(current_user)
            else
              redirect_to list_my_sales_user_path(current_user)
            end
          end
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
