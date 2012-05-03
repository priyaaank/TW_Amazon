require 'spec_helper'

describe SilentAuction do

  describe 'to be valid' do
    it 'should have a title' do
      auction = SilentAuction.new(:description => "my description")
      auction.valid?.should == false
      auction.title = "my title"
      auction.valid?.should == true
    end

    it "should have a unique title" do
      auction1 = SilentAuction.create(:title => "a", :description => "my description")
      auction1.should be_valid
      auction2 = SilentAuction.create(:title => "a  ", :description => "my description")
      auction2.should_not be_valid
      auction2.should have_at_least(1).errors_on(:title)
    end
    
    it 'should have a description' do 
      auction = SilentAuction.new(:title => "my title")
      auction.valid?.should == false
      auction.description = "this is default description"
      auction.valid?.should == true
    end
    

    it 'should default to open' do
      auction = SilentAuction.create!(:title => "my title", :description => "my description")
      auction.open.should == true 
    end
    
    it 'should not allow titles longer than 255' do
      auction = SilentAuction.new(:description => "my description")
      
      auction.title = "A" * 256
      auction.valid?.should == false
      
      auction.title = "A" * 255
      auction.valid?.should == true
    end
    
    it 'should not allow descriptions longer than 500' do
      auction = SilentAuction.new(:title => "my title")
      auction.description = "A" * 501
      auction.valid?.should == false
      
      auction.description = "A" * 500
      auction.valid?.should == true
    end
  end

  describe 'close' do
    before(:each) do
      @auction = SilentAuction.make!
    end

    it 'should close auction with at least one active bid' do
      user = User.make!(:user)
      user.bids.create(:silent_auction_id => @auction.id, :amount => 100)
      @auction.close
      @auction.open.should == false
    end

    it 'should not be closed if have no active bid' do
      @auction.close
      @auction.open.should == true
      @auction.should have_at_least(1).errors
    end
  end

end
