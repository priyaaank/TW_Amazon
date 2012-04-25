module SilentAuctionsHelper

  # return bid user has placed for the provided auction
  def user_bid_for_auction(auction)
    bid = current_user.bids.where(:silent_auction_id => auction.id).first
  end

  # return winner name
  def won_bid_for_auction(auction)
    winBid = auction.bids.active.highFirst.first
  end

end
