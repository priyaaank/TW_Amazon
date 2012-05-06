require 'spec_helper'

describe UsersController do
  include Devise::TestHelpers

  describe "GET 'show'" do

    describe "for non-signed-in users" do
      it 'should redirect to login page' do
        get :show
        if Rails.application.config.test_mode
          response.should redirect_to(root_path)
        else
          response.should redirect_to(user_omniauth_authorize_path(:cas))
        end
      end
    end

    describe "for signed-in non-admin users" do
      before(:each) do
        @user = User.make!(:user)
        sign_in @user
      end

      it "should return http success" do
        get :show, :id => @user.id
        response.should be_success
      end
    end
  end
end
