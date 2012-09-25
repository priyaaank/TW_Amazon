class HomeController < ApplicationController
  include ApplicationHelper

  def login
    if user_signed_in?
      redirect_to index_path
    else
      if test_mode?
        # provide homepage with two login options (CAS or test accounts)
        @title = "Login"
        respond_to do |format|
          format.html # login.html.haml
        end
      else
        redirect_to user_omniauth_authorize_path(:cas)
        # redirect_to index_path
      end
    end
  end
end
