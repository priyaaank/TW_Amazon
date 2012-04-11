require 'spec_helper'

describe SessionsController do
  describe '"GET" cas' do
    describe 'when the auth cannot be created' do
      it 'should redirect to the CAS login page'
    end

    describe 'when the user cannot be created' do
      it 'should redirect to the CAS login page'
    end

    describe 'when the hash is valid' do
      it 'should root path'
    end
  end

  describe 'GET "new"' do
    describe 'when user has logged in' do
      it 'should redirect to root page'
    end

    describe 'when user has not logged in' do
      it 'should redirect to CAS login page'
    end
  end

  describe 'GET "destroy"' do
    describe 'when user has logged in' do
      it 'should destroy current session'
      it 'should redirect to CAS logout page'
    end

    describe 'when user has not logged in' do
      it 'should redirect to CAS login page'
    end
  end
end
