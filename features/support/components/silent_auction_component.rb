module SilentAuctionModule
  def create_silent_auction
    add :silent_auctions, SilentAuction.make!
  end

  def create_silent_auction_from_hash hash
    visit new_silent_auction_path
    fill_in("silent_auction[title]", :with => hash['title'])
    fill_in("silent_auction[description]", :with => hash['description'])
    click_button "submit_done"

    #add :silent_auctions, SilentAuction.make!(hash)
  end

  def verify_silent_auction_has_title silent_auction
    silent_auction.title.blank?.should == false
  end
  
  def verify_silent_auction_has_description silent_auction
    silent_auction.description.blank?.should == false
  end

  def verify_silent_auction_is_open silent_auction
    silent_auction.open?.should == true
  end

  def verify_silent_auction_is_closed silent_auction
    silent_auction.open?.should == false
  end
end