class UsersController < ApplicationController
  include SilentAuctionsHelper

  def show
    @user = User.find(params[:id])
    @bids = @user.bids
  end

end
