class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :correct_user

  include SilentAuctionsHelper

  def show
    @user = User.find(params[:id])
    @bids = @user.bids
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user == @user
  end

end
