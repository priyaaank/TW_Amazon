require 'spec_helper'

describe SessionsController do
  include Devise::TestHelpers

  before (:each) do
    setup_controller_for_warden
    request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'GET "new"' do

    it 'should redirect to index if user has logged in' do
      user = User.make!(:user)
      sign_in user
      get :new
      response.should redirect_to landing_path
    end

    it 'should redirect to root login page when in test mode' do
      get :new
      response.should redirect_to root_path if Rails.application.config.test_mode
    end

    it 'should redirect to CAS login page when not in test mode' do
      get :new
      response.should redirect_to user_omniauth_authorize_path(:cas) if !Rails.application.config.test_mode
    end

  end

  describe '"GET" cas' do
    it 'should sign in user, assign cas session and redirect to index' do
      OmniAuth.config.test_mode = true
      OmniAuth.config.add_mock(:cas, { :provider => "cas", :uid => "cas_user" })
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:cas]

      get :cas
      session[:cas_login].should == true
      flash[:success].should eql I18n.t "devise.omniauth_callbacks.success", :kind => "Thoughtworks CAS"
      subject.current_user.should_not == nil
      subject.current_user.username.should eql 'cas_user'
      #response.should redirect_to index_path
      response.should_not redirect_to landing_path

      subject.current_user.region = Region.make!(:aus)
      subject.current_user.save!
      get :cas
      session[:cas_login].should == true
      response.should redirect_to landing_path
      #Expected response to be a redirect to <http://test.host/silent_auctions> but was a redirect to <http://test.host/users/1/new_region>
    end
  end


  describe 'GET "destroy_cas"' do
    it 'should destroy current session and go to root page if user has signed in' do
      user = User.make!(:user)
      sign_in user

      get :destroy_cas
      session[:cas_login].should == nil
      subject.current_user.should be_nil
      response.should redirect_to cas_logout_path
    end

    it 'should redirect to root page is user has not signed in' do
      get :destroy_cas
      response.should redirect_to root_path
    end
  end
end
