require 'spec_helper'

describe HomeController do
  describe "GET 'login'" do
    it "should redirect to test user login for non production environment" do
      get 'login'
      response.should redirect_to(new_user_session_path)
    end

    it 'should redirect to cas login in production mode' do
      Rails.stub(env: ActiveSupport::StringInquirer.new("production"))
      get 'login'
      response.should redirect_to(user_omniauth_authorize_path(:saml))
    end

    it 'should redirect to home page for a signed in user' do
      @user = User.make!(:user, :region => Region.make!(:aus))
      sign_in @user

      get 'login'
      response.should redirect_to(landing_path)
    end
  end
end
