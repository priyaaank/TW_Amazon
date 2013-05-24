class DummySessionsController < Devise::SessionsController

  def new
    @title = "Login with Test Account"
    @test_username = []
    @test_users = User.where("encrypted_password is NOT NULL")

    @test_users.each do |user|
      @test_username.push(user.username)
    end
    super
  end

  def after_sign_in_path_for(resource)
    landing_path
  end

  def destroy
    if user_signed_in?
      flash[:success] = I18n.t "devise.sessions.signed_out"
      sign_out_and_redirect current_user
    else
      redirect_to root_path
    end
  end
end
