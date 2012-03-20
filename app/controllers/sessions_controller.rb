class SessionsController < ApplicationController
  def cas
    user = User.find_or_create_from_auth_hash(auth_hash)
    sign_in_and_redirect :user, user
  end

  protected
  def auth_hash
    request.env['omniauth.auth']
  end
end