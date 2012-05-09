class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :correct_user

  def show
    @user = User.find(params[:id])
    @running_bids = @user.bids.joins(:silent_auction).where(:silent_auctions => {:open => true})
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user == @user
  end

end
