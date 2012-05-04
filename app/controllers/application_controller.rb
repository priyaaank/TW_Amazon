class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user!, :except => [:login]

  # This action is supposed to only be accessed in the test environment.
  # This is for being able of running the cucumber tests.
  def login
    @user = User.find(params[:id])
    sign_in(@user)
    current_user = @user
  end

end
