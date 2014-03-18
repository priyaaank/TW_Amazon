require 'spec_helper'

describe SessionsController do
  include Devise::TestHelpers

  before (:each) do
    setup_controller_for_warden
    Rails.stub(env: ActiveSupport::StringInquirer.new("production"))
    request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'GET "new"' do

    it 'should redirect to index if user has logged in' do
      user = User.make!(:user)
      sign_in user
      get :new
      response.should redirect_to landing_path
    end

    it 'should redirect to SAML login page in production mode' do
      get :new
      response.should redirect_to user_omniauth_authorize_path(:saml)
    end

  end

  describe '"GET" saml' do
    it 'should sign in user, assign saml session and redirect to index' do
      OmniAuth.config.test_mode = true
      OmniAuth.config.add_mock(:saml, { :provider => "saml", :uid => "saml_user" })
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:saml]

      get :saml
      session[:saml_login].should == true
      flash[:success].should eql I18n.t "devise.omniauth_callbacks.success", :kind => "Thoughtworks SAML"
      subject.current_user.should_not == nil
      subject.current_user.username.should eql 'saml_user'
      response.should_not redirect_to landing_path

      subject.current_user.region = Region.make!(:aus)
      subject.current_user.save!
      get :saml
      session[:saml_login].should == true
      response.should redirect_to landing_path
    end
  end
end
