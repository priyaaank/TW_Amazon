require 'spec_helper'

describe HomeController do

  describe "GET 'login'" do
    it "returns http success in test mode" do
      get 'login'
      if Rails.application.config.test_mode
        response.should be_success
      end
    end

    it 'should redirect to cas login if not in test mode' do
      get 'login'
      if !Rails.application.config.test_mode
        response.should redirect_to(user_omniauth_authorize_path(:cas))
      end
    end
  end

end
