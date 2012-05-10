require 'spec_helper'

describe SilentAuction do

  describe 'to be valid' do
    it 'should have a title' do
      auction = SilentAuction.new(:description => "my description", :min_price => 250.00)
      auction.valid?.should == false
      auction.title = "my title"
      auction.valid?.should == true
    end

    it "should have a unique title" do
      auction1 = SilentAuction.create(:title => "a", :description => "my description", :min_price => 250.00)
      auction1.should be_valid
      auction2 = SilentAuction.create(:title => "a  ", :description => "my description", :min_price => 250.00)
      auction2.should_not be_valid
      auction2.should have_at_least(1).errors_on(:title)
    end
    
    it 'should have a description' do 
      auction = SilentAuction.new(:title => "my title", :min_price => 250.00)
      auction.valid?.should == false
      auction.description = "this is default description"
      auction.valid?.should == true
    end
    
    it 'should default to open' do
      auction = SilentAuction.create!(:title => "my title", :description => "my description", :min_price => 250.00)
      auction.open.should == true 
    end
    
    it 'should not allow titles longer than 255' do
      auction = SilentAuction.new(:description => "my description", :min_price => 250.00)
      
      auction.title = "A" * 256
      auction.valid?.should == false
      
      auction.title = "A" * 255
      auction.valid?.should == true
    end
    
    it 'should not allow descriptions longer than 500' do
      auction = SilentAuction.new(:title => "my title", :min_price => 250.00)
      auction.description = "A" * 501
      auction.valid?.should == false
      
      auction.description = "A" * 500
      auction.valid?.should == true
    end

    it 'should have a minimum price' do
      auction = SilentAuction.new(title: "a", description: "b")
      auction.valid?.should == false
      auction.should have_at_least(1).errors_on(:min_price)
      auction.min_price = 250.00
      auction.valid?.should == true
    end

    it 'should not allow minimum price less or equal to 0' do
      auction = SilentAuction.new(title: "a", description: "b")

      auction.min_price = -99
      auction.valid?.should == false
      auction.should have_at_least(1).errors_on(:min_price)

      auction.min_price = 0
      auction.valid?.should == false
      auction.should have_at_least(1).errors_on(:min_price)
    end

    it 'should not allow invalid number for min price' do
      auction = SilentAuction.new(title: "a", description: "b")

      auction.min_price = "ddsaas"
      auction.valid?.should == false
      auction.should have_at_least(1).errors_on(:min_price)
    end

    it 'should not allow min price greater than 9999.00' do
      auction = SilentAuction.new(title: "a", description: "b")

      auction.min_price = 34322.32
      auction.valid?.should == false
      auction.should have_at_least(1).errors_on(:min_price)

      auction.min_price = 9999.99
      auction.valid?.should == true
    end

    it "should have an end date" do
      auction = SilentAuction.make!
      auction.end_date.should == 2.weeks.from_now.to_date
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

    it 'should automatically close auctions with bids that are ending today' do
      @auction.end_date = Date.today
      user = User.make!(:user)
      user.bids.create(:silent_auction_id => @auction.id, :amount => 100)
      
      @auction.save!
      SilentAuction.close_auctions_ending_today
      @auction.reload

      @auction.open.should be_false
    end

    it 'should automatically close auctions that do not have any bids and are ending today' do
      @auction.end_date = Date.today

      @auction.save!
      SilentAuction.close_auctions_ending_today
      @auction.reload

      @auction.open.should be_false
    end

    it 'should not automatically close auctions with bids that are not ending today' do
      @auction.end_date = Date.tomorrow
      user = User.make!(:user)
      user.bids.create(:silent_auction_id => @auction.id, :amount => 100)

      @auction.save!
      SilentAuction.close_auctions_ending_today
      @auction.reload

      @auction.open.should be_true
    end
  end
end
