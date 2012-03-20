require 'spec_helper'

describe SessionsController do
  describe '"GET" cas' do
    describe 'when the auth cannot be created' do
      it 'should redirect to the login page'
    end

    describe 'when the user cannot be created' do
      it 'should redirect to the login page'
    end

    describe 'when the hash is valid' do
      it 'should root path'
    end
  end
end
