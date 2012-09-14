class CustomFailure < Devise::FailureApp
  def redirect_url
    root_path
  end

  # THIS WILL MAKE ALL AUTHENTICATION FAILURE (EVEN IN LOGIN) GO TO ROOT PATH
  #def respond
  #  if http_auth?
  #    http_auth
  #  else
  #    redirect
  #  end
  #end
end
