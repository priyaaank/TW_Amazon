class UsersController < ApplicationController
  include ApplicationHelper
  include SilentAuctionsHelper

  before_filter :authenticate_user!
  before_filter :correct_user

  def faq_page
    @title = "Frequently Asked Questions (and the answers)"

  end

  def show
    @title = "My Bids"
    @user = User.find(params[:id])
    @running_bids = @user.bids.joins(:silent_auction).where(:silent_auctions => {:open => true}).where("region = ? AND item_type = 'Silent Auction'", @user.region).recent
    @running_normal_bids = @user.bids.joins(:silent_auction).where(:silent_auctions => {:open => true}).where("region = ? AND item_type = 'Normal Auction'", @user.region).recent
    @closed_bids = @user.bids.joins(:silent_auction).where(:silent_auctions => {:open => false}).where("bids.active = ? AND region = ?", true, @user.region).recent
  end

  def list_my_items
    @title = "My Silent Auctions"
    @user = User.find(params[:id])
    puts "*" * 40
    puts @user.username
    @timezone = @user.region.timezone
    @running_bids = SilentAuction.running(@timezone).where("creator = ? AND item_type = 'Silent Auction' AND region = ?", @user.username, @user.region).where({:open => true}).recent
    @closed_bids = SilentAuction.closed.where("creator = ? AND region = ? AND item_type ='Silent Auction'", @user.username, @user.region).recent
    @expired_bids = SilentAuction.expired.where("creator = ? AND region = ? AND item_type ='Silent Auction'", @user.username, @user.region).recent
    @future_bids = SilentAuction.future(@timezone).where({:open => true}).where("creator = ? AND item_type = 'Silent Auction' AND region = ?", @user.username, @user.region).recent#need timezone to filter the future auction items
  end

  def list_my_normal_auctions
    @title = "My Normal Auctions"
    @user = User.find(params[:id])
    puts "*" * 40
    puts @user.username
    @timezone = @user.region.timezone
    @running_bids = SilentAuction.running(@timezone).where("creator = ? AND item_type = 'Normal Auction' AND region = ?", @user.username, @user.region).where({:open => true}).recent
    @closed_bids = SilentAuction.closed.where("creator = ? AND region = ? AND item_type ='Normal Auction'", @user.username, @user.region).recent
    @expired_bids = SilentAuction.expired.where("creator = ? AND region = ? AND item_type ='Normal Auction'", @user.username, @user.region).recent
    @future_bids = SilentAuction.future(@timezone).where({:open => true}).where("creator = ? AND item_type = 'Normal Auction' AND region = ?", @user.username, @user.region).recent#need timezone to filter the future auction items
  end

  def list_my_sales
    @title = "My Sales"
    @user = User.find(params[:id])
    puts "*" * 40
    puts @user.username
    @timezone = @user.region.timezone
    @running_bids = SilentAuction.running(@timezone).where("creator = ? AND item_type = 'Quick Sale' AND region = ?", @user.username, @user.region).where({:open => true}).recent
    @future_bids = SilentAuction.future_sale(@timezone).where({:open => true}).where("creator = ? AND region = ?", @user.username, @user.region).recent#need timezone to filter the future auction items
  end

  def notification
    if @user.email == nil
      @user.email = 'on'
      @user.save
    end
    @user = current_user
  end

  def correct_user
    @user = User.find(params[:id])
    if current_user != @user
      flash[:error] = "<h4 class='alert-heading'>Unauthorized Access!</h4>Sorry, You don't have permission to view bids of other users".html_safe
      redirect_back_or(index_path)
    end
  end

  def new_region
    @regions = Region.all
    @user = User.find(params[:id])
  end

  def update_region
    @user.region = Region.find(params[:user][:region])
    @user.save!
    redirect_to index_path
  end

  def update
    @user = User.find(params[:id])
    region_id =  params[:user].delete(:region)
    @user.update_attributes(params[:user])
    @user.region = Region.find(params[:user][:region])
    redirect_to :back
  end
end
