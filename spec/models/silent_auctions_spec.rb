require 'spec_helper'

describe SilentAuction do
  describe 'to be valid' do
    it 'should have a title' do
      auction = SilentAuction.new(:description => "my description")
      auction.valid?.should == false
      auction.title = "my title"
      auction.valid?.should == true
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


end
