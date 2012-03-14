require 'spec_helper'

describe SilentAuctions do
  describe 'to be valid' do
    it 'should have a title' do
      auction = SilentAuctions.new(:description => "my description")
      auction.valid?.should == false
      auction.title = "my title"
      auction.valid?.should == true
    end
    
    it 'should have a description' do 
      auction = SilentAuctions.new(:title => "my title")
      auction.valid?.should == false
      auction.description = "this is default description"
      auction.valid?.should == true
    end
    

    it 'should default to open' do
      auction = SilentAuctions.create!(:title => "my title", :description => "my description")
      auction.open.should == true 
    end
    
    it 'should not allow titles longer than 255' do
      auction = SilentAuctions.new(:description => "my description")
      
      auction.title = "A" * 256
      auction.valid?.should == false
      
      auction.title = "A" * 255
      auction.valid?.should == true
    end
    
    it 'should not allow descriptions longer than 500' do
      auction = SilentAuctions.new(:title => "my title")
      auction.description = "A" * 501
      auction.valid?.should == false
      
      auction.description = "A" * 500
      auction.valid?.should == true
    end
  end
end
