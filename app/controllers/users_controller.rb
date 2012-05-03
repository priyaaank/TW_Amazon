class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @bids = @user.bids
  end

end
