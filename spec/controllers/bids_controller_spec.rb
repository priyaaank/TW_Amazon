require 'spec_helper'

describe BidsController do
  include Devise::TestHelpers

  describe "POST 'create'" do

    before(:each) do
      @user = User.make!(:user)
      sign_in @user
    end

    context "given a running auction" do

      it 'should create a new bid'

    end

    context "given a closed auction" do

      it 'should not create a new bid'

      it 'should display error message'
    end

  end

  describe "PUT 'withdraw'" do

    context "given a running auction" do

      it 'should withdraw the bid'

    end

    context "given a closed auction" do

      it 'should not withdraw the bid'

      it 'should display error message'
    end

  end

end
