class SessionsController < Devise::OmniauthCallbacksController
  include ApplicationHelper

  before_filter :authenticate_user!

  def new
    if user_signed_in?
      redirect_to landing_path
    elsif Rails.env.production?
      redirect_to user_omniauth_authorize_path(:saml)
    else
      redirect_to root_path
    end
  end

  def saml
    @user = User.find_or_create_from_auth_hash(auth_hash, current_user)
    if @user.persisted?
      session[:saml_login] = true # use session to differentiate login with cas or not
      flash[:success] = I18n.t "devise.omniauth_callbacks.success", :kind => "Thoughtworks SAML"
      sign_in_and_redirect @user, :event => :authentication
    end
  end

  def after_sign_in_path_for(resource_or_scope)
    if current_user.region.blank?
      new_region_user_path(current_user)
    else
      landing_path
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    cas_logout_path
  end

  protected
  def auth_hash
    request.env['omniauth.auth']
  end

end
