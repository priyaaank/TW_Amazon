def view_all_bids_for_auction_id(auction_id)
  auction = SilentAuction.find(auction_id)
  puts "ALL BIDS FOR AUCTION ID #{auction_id}"

  print_bids(auction.bids.active.highFirst.earlier)
end

def view_all_bids_for_auction_title(auction_title)
  auction = SilentAuction.find_by_title(auction_title)
  print_bids(auction.bids.active.highFirst.earlier)
end

def print_bids(bids)
  puts 'SORTED BY HIGHEST AMOUNT THEN EARLIER BID TIME'

end