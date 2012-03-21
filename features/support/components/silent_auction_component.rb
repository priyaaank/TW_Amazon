module SilentAuctionModule
  def create_silent_auction
    add :silent_auctions, SilentAuction.make!
  end

  def verify_silent_auction_has_title silent_auction
    silent_auction.title.blank?.should == false
  end
  
  def verify_silent_auction_has_description silent_auction
    silent_auction.description.blank?.should == false
  end
  
end