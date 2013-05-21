require 'spec_helper'

describe DummySessionsController do
  include Devise::TestHelpers

  before (:each) do
    setup_controller_for_warden
    request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'GET "new"' do
    describe 'when user not login' do
      it 'should display the list of usernames of test users' do
        # create some test users
        user1 = User.make!(:user)
        user2 = User.make!(:user)
        admin1 = User.make!(:admin)
        casUser = User.make!(:casUser)

        get :new
        assigns[:test_username].should include(user1.username)
        assigns[:test_username].should include(user2.username)
        assigns[:test_username].should include(admin1.username)
        assigns[:test_username].should_not include(casUser.username)
      end
    end

    describe 'when user already logged in' do

      it 'should redirect to index page' do
        user = User.make!(:user)
        sign_in user
        get :new
        response.should redirect_to (index_path)
      end
    end
  end

  describe 'GET "destroy"' do
    it 'should destroy current session and go to root page if user has signed in' do
      user = User.make!(:user)
      sign_in user

      get :destroy
      subject.current_user.should be_nil
      response.should redirect_to root_path
    end

    it 'should redirect to root page is user has not signed in' do
      get :destroy
      response.should redirect_to root_path
    end
  end

end
