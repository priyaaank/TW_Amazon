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
=begin
    it 'should not allow min price greater than 9999.00' do
      auction = SilentAuction.new(title: "a", description: "b")

      auction.min_price = 34322.32
      auction.valid?.should == false
      auction.should have_at_least(1).errors_on(:min_price)

      auction.min_price = 9999.99
      auction.valid?.should == true
    end

    it "should have an automatic 2 weeks from now on end date" do
      auction = SilentAuction.make!
      auction.end_date.should == 2.weeks.from_now.to_date
    end
=end
    it "should have an end date between the start date up to 2 months forwards" do
      auction = SilentAuction.new(title: "a", description: "b", start_date: Date.today, end_date: Date.today - 1.day)
      auction.check_dates.should == false
      
      auction = SilentAuction.new(title: "a", description: "b", start_date: Date.today, end_date: Date.today)
      auction.check_dates.should == nil

      auction = SilentAuction.new(title: "a", description: "b", start_date: Date.today + 15.days, end_date: Date.today + 76.days)
      auction.check_dates.should == nil

      auction = SilentAuction.new(title: "a", description: "b", start_date: Date.today, end_date: Date.today + 2.months)
      auction.check_dates.should == nil

      auction = SilentAuction.new(title: "a", description: "b", start_date: Date.today, end_date: Date.today + 2.months + 1.day)
      auction.check_dates.should == false
    end
  end

  describe 'close_auctions_ending_today' do
    before(:each) do
      @auction = SilentAuction.make!
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
    before(:each) do
      @auction1 = SilentAuction.make!
      @auction2 = SilentAuction.make!
      @auction3 = SilentAuction.make!(:open => false)

      @running_auctions = SilentAuction.running
    end

    it 'should return all auctions that are open' do
      @running_auctions.should include @auction1
      @running_auctions.should include @auction2
    end

    it 'should not return any closed auctions' do
      @running_auctions.should_not include @auction3
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
