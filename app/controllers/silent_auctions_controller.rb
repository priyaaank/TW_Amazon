class SilentAuctionsController < ApplicationController
  include ApplicationHelper
  include SilentAuctionsHelper

  before_filter :authenticate_user!
  before_filter :ensure_signed_in_user_has_a_region, :only => [:index, :closed, :expired, :future]

  # GET /silent_auctions/running
  def index
    @title = "Running Silent Auctions"
    @running_auctions = SilentAuction.running_silent_auction(current_user.timezone).recent.includes(:bids).find_by_region_id(current_user.region)
  end

  # GET /silent_auctions/normal_auctions
  def normal_auctions
    @title = "Running Auctions"
    @running_auctions = SilentAuction.running_normal_auction(current_user.timezone).recent.includes(:bids).find_by_region_id(current_user.region)
  end

  def sales
    @title = "Quick Sales Board"
    @running_auctionss = SilentAuction.running_quick_sales(current_user.timezone).recent.find_by_region_id(current_user.region)
  end

  def closed
    @title = "Closed Auctions Listing"
    @closed_auctions = SilentAuction.closed.recent.page(params[:page]).find_by_region_id(current_user.region)
  end

  def expired
    @title = "Expired Auctions Listing"
    @expired_auctions = SilentAuction.expired.order("end_date DESC").page(params[:page]).find_by_region_id(current_user.region)
  end

  def future
    @title = "Future Auctions Listing"
    @future_auctions = SilentAuction.future(current_user.timezone).recent.page(params[:page])
  end

  def new
    @title = "Create new auction"
    @silent_auction = SilentAuction.new
    @silent_auction.photos.build
  end

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
              # else
                # format.html {redirect_to list_my_sales_user_path(current_user)}
              else if @silent_auction.item_type == 'Normal Auction'
                format.html {redirect_to list_my_normal_auctions_user_path(current_user)}
              else
                format.html {redirect_to list_my_sales_user_path(current_user)}
              end #end of else if
              end
            end
        end
        unless Rails.application.config.test_mode
          if @silent_auction.start_date.to_date == Time.zone.now.in_time_zone(@currentuser.timezone).to_date
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
          # if current_user.admin == true
            # flash[:success] = "<b>#{@silent_auction.title}</b> was successfully updated!".html_safe
            # if @silent_auction.item_type == 'Silent Auction'
              # redirect_to silent_auctions_path
            # else if @silent_auction.item_type == 'Normal Auction'
              # redirect_to normal_auctions_silent_auctions_path
            # else
              # redirect_to sales_silent_auctions_path
            # end #end of else if
            # end
          # else
            flash[:success] = "<b>#{@silent_auction.title}</b> was successfully updated!".html_safe
            #redirect_to sales_silent_auctions_path
            if @silent_auction.item_type == 'Silent Auction'
              redirect_to list_my_items_user_path(current_user)
            else if @silent_auction.item_type == 'Normal Auction'
              redirect_to list_my_normal_auctions_user_path(current_user)
            else
              redirect_to list_my_sales_user_path(current_user)
            end #end of else if
            end
          # end
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
