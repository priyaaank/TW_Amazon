require 'spec_helper'

describe SilentAuction do
  #Time.zone = timezone = "Melbourne"
  describe 'to be valid' do    
    it 'should have a title' do
      auction = SilentAuction.make
      auction.title = nil
      auction.valid?.should == false
      auction.title = "my title"
      auction.valid?.should == true
    end

    it "should have a unique title" do
      auction1 = auction = SilentAuction.make!
      auction1.should be_valid
      auction2 = auction = SilentAuction.make(:title => auction1.title)
      auction2.should_not be_valid
      auction2.should have_at_least(1).errors_on(:title)
    end
    
    it 'should have a description' do 
      auction = SilentAuction.make
      auction.description = nil
      auction.valid?.should == false
      auction.description = "this is default description"
      auction.valid?.should == true
    end
    
    it 'should default to open' do
      auction = SilentAuction.make!
      auction.open.should == true 
    end
    
    it 'should not allow titles longer than 255' do
      auction = SilentAuction.make
      
      auction.title = "A" * 256
      auction.valid?.should == false
      
      auction.title = "A" * 255
      auction.valid?.should == true
    end
    
    it 'should not allow descriptions longer than 500' do
      auction = SilentAuction.make
      auction.description = "A" * 501
      auction.valid?.should == false
      
      auction.description = "A" * 500
      auction.valid?.should == true
    end

    it 'should have a minimum price' do
      auction = SilentAuction.make
      auction.min_price = nil
      auction.valid?.should == false
      auction.should have_at_least(1).errors_on(:min_price)
      auction.min_price = 250.00
      auction.valid?.should == true
    end

    it 'should not allow minimum price less or equal to 0' do
      auction = SilentAuction.make

      auction.min_price = -99
      auction.valid?.should == false
      auction.should have_at_least(1).errors_on(:min_price)

      auction.min_price = 0
      auction.valid?.should == false
      auction.should have_at_least(1).errors_on(:min_price)
    end

    it 'should not allow invalid number for min price' do
      auction = SilentAuction.make

      auction.min_price = "ddsaas"
      auction.valid?.should == false
      auction.should have_at_least(1).errors_on(:min_price)
    end
    
    it 'should not allow a nil start date' do
      auction = SilentAuction.make(:start_date => nil)
      auction.valid?.should be_false
      auction.should have_at_least(1).errors_on(:start_date) 
    end
    
    it 'should not allow a nil end date' do
      auction = SilentAuction.make(:end_date => nil)
      auction.valid?.should be_false
      auction.should have_at_least(1).errors_on(:end_date)       
    end
    
    it 'should not allow a start date before today' do
      auction = SilentAuction.make(:start_date => Date.yesterday)
      auction.valid?.should be_false
      auction.should have_at_least(1).errors_on(:start_date)  
    end
    it 'should not allow an end date before start date' do
      auction = SilentAuction.make
      auction.start_date=Date.tomorrow
      auction.end_date=auction.start_date-1.day
      auction.valid?.should be_false
      auction.should have_at_least(1).errors_on(:end_date) 
    end
    
    it 'should not allow an end date more than 2 months from the start date' do
      auction = SilentAuction.make
      auction.start_date=Date.today+2.months
      auction.end_date=auction.start_date+2.month+1.day
      auction.valid?.should be_false
      auction.should have_at_least(1).errors_on(:end_date) 
    end
    
    it 'should default region to AUS' do
      auction=SilentAuction.make
      auction.region=nil
      auction.save!
      auction.reload
      auction.region.should=="AUS"
    end
  end

  describe 'close_auctions_ending_today' do
    before(:each) do
      @auction = SilentAuction.make!(:region => "IND")
      @auction.end_date = Date.today
      @auction2 = SilentAuction.make!(:region => "AUS")
      @auction2.end_date = Date.today
    end
    it 'should automatically close auctions with bids that are ending today' do
      Timecop.freeze(Date.today + 1.day) do
        #@auction.end_date = Date.today
        user = User.make!(:user)
        user.bids.create(:silent_auction_id => @auction.id, :amount => 1000.99)
        user.bids.create(:silent_auction_id => @auction2.id, :amount => 1000.99)
  
        @auction.save!
        @auction2.save!
        SilentAuction.close_auctions_ending_today
        @auction.reload
        @auction2.reload
        
        @auction.open.should be_false
        @auction2.open.should be_false
      end
    end

    it 'should automatically close auctions that do not have any bids and are ending today' do
      Timecop.freeze(Date.today + 1.day) do
        #@auction.end_date = Date.today
  
        @auction.save!
        SilentAuction.close_auctions_ending_today
        @auction.reload

        @auction.open.should be_false
      end
    end

    it 'should not automatically close auctions with bids that are not ending today' do
      @auction.end_date = Date.today + 1.day
      user = User.make!(:user)
      user.bids.create(:silent_auction_id => @auction.id, :amount => 100)

      @auction.save!
      SilentAuction.close_auctions_ending_today
      @auction.reload

      @auction.open.should be_true
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

  describe "scope 'running'" do
    it 'should return all auctions that are open' do
      auction = SilentAuction.make!(:open => true)
      @timezone = "Melbourne"
      running_auctions = SilentAuction.running(@timezone)
      
      running_auctions.should include auction
    end

    it 'should not return any closed auctions' do
      auction = SilentAuction.make!(:open => false)
      @timezone = "Melbourne"
      running_auctions = SilentAuction.running(@timezone)
      
      running_auctions.should_not include auction
    end
    
    it 'should return auctions created today' do
      start = SilentAuction.make!(:start_date => Time.now.beginning_of_day.to_date.to_s)
      last = SilentAuction.make!(:start_date => Time.now.end_of_day.to_date.to_s)
      @timezone = "Melbourne"
      running = SilentAuction.running(@timezone)
      running.should include start
      running.should include last
    end
    
    it 'should not return auctions created tomorrow' do
      tomorrow = SilentAuction.make!(:start_date => Date.today + 1.day)
      @timezone = "Melbourne"
      running = SilentAuction.running(@timezone)
      running.should_not include tomorrow
    end
  end

  describe "scope 'closed'" do
    before(:each) do
      @auction1 = SilentAuction.make!
      @auction2 = SilentAuction.make!
      @auction3 = SilentAuction.make!(:open => false)
      @auction4 = SilentAuction.make!

      User.make!(:user).bids.create(:silent_auction_id => @auction1.id, :amount => 100)
      User.make!(:user).bids.create(:silent_auction_id => @auction2.id, :amount => 100)

      @auction1.change_to_closed
      @auction2.change_to_closed

      @closed_auctions = SilentAuction.closed
    end

    it 'should return only closed auctions that have at least bids' do
      @closed_auctions.should include @auction1
      @closed_auctions.should include @auction2
    end

    it 'should not return closed auctions that have no bids' do
      @closed_auctions.should_not include @auction3
    end

    it 'should not return running auctions' do
      @closed_auctions.should_not include @auction4
    end
  end

  describe "scope 'expired'" do
    before(:each) do
      @auction1 = SilentAuction.make!(:open => false)
      @auction2 = SilentAuction.make!(:open => false)
      @auction3 = SilentAuction.make!
      @auction4 = SilentAuction.make!

      User.make!(:user).bids.create(:silent_auction_id => @auction3.id, :amount => 100)
      @auction3.change_to_closed
      @expired_auctions = SilentAuction.expired
    end

    it 'should return all closed auctions that have no bids' do
      @expired_auctions.should include @auction1
      @expired_auctions.should include @auction2
    end

    it 'should not return closed auction that have bids' do
      @expired_auctions.should_not include @auction3
    end

    it 'should not return running auctions' do
      @expired_auctions.should_not include @auction4
    end
  end
end
