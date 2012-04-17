class DummySessionsController < Devise::SessionsController
  include ApplicationHelper

  def new
    if test_mode?
      @title = "Login with Test Account"
      @test_username = []
      @test_users = User.where("encrypted_password is NOT NULL")

      @test_users.each do |user|
        @test_username.push(user.username)
      end
      super
    else
      redirect_to user_omniauth_authorize_path(:cas)
    end
  end

  def create
    super
  end

  def destroy
    if user_signed_in?
      sign_out_and_redirect current_user
    else
      redirect_to root_path
    end
  end
end
