require 'spec_helper'

describe User do
  let(:valid_user) {{:username => "cool_user"}}

  describe 'to be valid' do

    it 'should have a username' do
      requires :username
    end

    it 'should have a username less than 255 characters' do
      has_limit :username, 255
    end
  end


  describe 'find_or_create_from_auth_hash' do
    let(:auth_hash) {{:provider => :cas, :uid => 'cool_user'}}

    it 'should find a user using username if one exists' do
      existing_user = User.create!(valid_user)

      user = User.find_or_create_from_auth_hash(auth_hash)
      user.should == existing_user
    end

    it 'should create a user using uid if one exists' do
      user = User.find_or_create_from_auth_hash(auth_hash)
      user.username.should == "cool_user"
    end

    it 'should return nil if uid is not supplied' do
      User.find_or_create_from_auth_hash(nil).nil?.should == true
      User.find_or_create_from_auth_hash({}).nil?.should == true
      User.find_or_create_from_auth_hash({:uid => ""}).nil?.should == true
    end
  end
end
