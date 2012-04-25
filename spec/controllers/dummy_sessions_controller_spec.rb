require 'spec_helper'

describe DummySessionsController do

  describe 'GET "new"' do
    describe 'when user not login' do
      it 'should display the list of test users'
    end

    describe 'when user already logged in' do
      it 'should redirect to index page'
    end
  end

  describe 'GET "destroy"' do
    it 'should go back to homepage after sign out'
  end

end
