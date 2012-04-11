class SessionsController < Devise::OmniauthCallbacksController
  before_filter :authenticate_user!

  def new
    if user_signed_in?
      redirect_to root_path
    else
      redirect_to user_omniauth_authorize_path(:cas)
    end
  end

  def cas
    @user = User.find_or_create_from_auth_hash(auth_hash, current_user)

    if @user.persisted?
      flash[:success] = I18n.t "devise.omniauth_callbacks.success", :kind => "Thoughtworks CAS"
      sign_in_and_redirect @user, :event => :authentication
    end
  end

  def destroy
    if user_signed_in?
      sign_out_and_redirect current_user
    else
      redirect_to user_omniauth_authorize_path(:cas)
    end
  end

  def cas_logout
    redirect_to "http://cas.thoughtworks.com/cas/logout"
  end

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    cas_logout_path
  end

  protected
  def auth_hash
    request.env['omniauth.auth']
  end

end