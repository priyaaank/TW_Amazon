class UsersController < ApplicationController
  include ApplicationHelper

  before_filter :authenticate_user!
  before_filter :correct_user

  def show
    @title = "My Bids"
    @user = User.find(params[:id])
    @running_bids = @user.bids.joins(:silent_auction).where(:silent_auctions => {:open => true}).recent
    @closed_bids = @user.bids.joins(:silent_auction).where(:silent_auctions => {:open => false}).recent
  end

  def list_my_items
    @title = "My Items"
    @user = User.find(params[:id])
    puts "*" * 40
    puts @user.username
    @items = SilentAuction.where("creator = ?", @user.username)#.find_by_creator(@user.username)
    #@items = @user.creator.joins(:silent_auction)
    puts "*" * 40
    puts @items.count
    @running_bids = @items.where({:open => true}).recent
    @future_bids = @items.where({:open => true}).recent#need timezone to filter the future auction items
  end

  def correct_user
    @user = User.find(params[:id])
    if current_user != @user
      flash[:error] = "<h4 class='alert-heading'>Unauthorized Access!</h4>Sorry, You don't have permission to view bids of other users".html_safe
      redirect_back_or(index_path)
    end
  end
  
  def new_region
    @user = User.find(params[:id])
  end
  
  def update_region
    @user.region = params[:user][:region]
    @user.save!
    redirect_to index_path
  end
  
  def update
    @user = User.find(params[:id])
    #@user.region = params[:current_user] 
    #@user.save
    @user.update_attributes(params[:user])
    #redirect_to silent_auctions_path
    # timezone = get_region_config(@user.region)["timezone"]
    redirect_to(:back)
  end
end
