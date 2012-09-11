class UsersController < ApplicationController
  include ApplicationHelper

  before_filter :authenticate_user!
  before_filter :correct_user

  def show
    @title = "My Auctions"
    @user = User.find(params[:id])
    @running_bids = @user.bids.joins(:silent_auction).where(:silent_auctions => {:open => true}).recent
    @closed_bids = @user.bids.joins(:silent_auction).where(:silent_auctions => {:open => false}).recent
  end

  def correct_user
    @user = User.find(params[:id])
    if current_user != @user
      flash[:error] = "<h4 class='alert-heading'>Unauthorized Access!</h4>Sorry, You don't have permission to view bids of other users".html_safe
      redirect_back_or(index_path)
    end
  end
  
  def update
    @user = User.find(params[:id])
    #@user.region = params[:current_user] 
    #@user.save
    @user.update_attributes(params[:user])
    #redirect_to silent_auctions_path
    redirect_to(:back)
  end
end
