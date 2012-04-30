require 'spec_helper'

describe BidsController do

  describe "POST 'create'" do

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
