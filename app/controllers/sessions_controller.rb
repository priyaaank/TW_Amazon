class SessionsController < Devise::OmniauthCallbacksController
  include ApplicationHelper

  before_filter :authenticate_user!
  before_filter :loginRedirect, :only => [:new]

  def loginRedirect
    if user_signed_in?
      redirect_to index_path
    end
  end

  def new
    # provide homepage with two login options (CAS or dummy) if app is still running in test mode
    if test_mode?
      flash[:error] = I18n.t "devise.failure.unauthenticated"
      redirect_to root_path
    else
      # in real application (non-test-mode) redirect users directly to CAS login page
      redirect_to user_omniauth_authorize_path(:cas)
    end
  end

  # Authenticate user with CAS login
  def cas
    @user = User.find_or_create_from_auth_hash(auth_hash, current_user)

    if @user.persisted?
      session[:cas_login] = true # use session to differentiate login with cas or not
      flash[:success] = I18n.t "devise.omniauth_callbacks.success", :kind => "Thoughtworks CAS"
      sign_in_and_redirect @user, :event => :authentication
    end
  end

  def destroy_cas
    if user_signed_in?
      session[:cas_login] = nil
      sign_out_and_redirect current_user
    else
      redirect_to root_path
    end
  end

  # Overwriting the sign_out redirect path method
  def after_sign_in_path_for(resource_or_scope)
    index_path
  end

  def after_sign_out_path_for(resource_or_scope)
    "http://cas.thoughtworks.com/cas/logout"
  end

  protected
  def auth_hash
    request.env['omniauth.auth']
  end

end