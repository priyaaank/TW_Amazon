class SessionsController < Devise::OmniauthCallbacksController
  #before_filter :authenticate_user!

  def new
    respond_to do |format|
      if user_signed_in?
        format.html {redirect_to silent_auctions_path}
      else
        format.html # new.html.haml
      end
    end
  end

  def destroy
    if user_signed_in?
      flash[:success] = I18n.t "devise.sessions.signed_out"
      sign_out_and_redirect current_user
    end
  end

  def destroy_cas
    if user_signed_in?
      sign_out current_user
      redirect_to "http://cas.thoughtworks.com/cas/logout"
    end
  end

  def cas
    @user = User.find_or_create_from_auth_hash(auth_hash, current_user)

    if @user.persisted?
      flash[:success] = I18n.t "devise.omniauth_callbacks.success", :kind => "Thoughtworks CAS"
      sign_in_and_redirect @user, :event => :authentication
    end

    #sign_in_and_redirect :user, user
  end

  protected
  def auth_hash
    request.env['omniauth.auth']
  end

end