module ConsoleHelper

  def view_all_bids_for_auction_id(auction_id)
    auction = SilentAuction.find(auction_id)
    bids = auction.bids.highFirst.earlier
    puts "AUCTION ID #{auction_id}"
    print_bids(bids)
  end

  def view_all_bids_for_auction_title(auction_title)
    auction = SilentAuction.find_by_title(auction_title)
    bids = auction.bids.highFirst.earlier
    puts "AUCTION '#{auction_title}'"
    print_bids(bids)
  end

  def print_bids(bids)
    if bids.empty?
      puts "AUCTION HAS NO BID"
    else
      puts 'BIDS SORTED BY HIGHEST AMOUNT THEN EARLIER TIME'
      puts '----------------------------------------------'
      puts "Bid ID | USERNAME | AMOUNT | STATUS"
      bids_output = []
      bids.each do |bid|
        username = User.find(bid.user_id).username
        bids_output.push "#{bid.id} | #{username} | $#{bid.amount} | #{bid.active ? 'active':'inactive'}"
      end
      bids_output
    end
  end

  def change_auction_end_date(auction_id, new_end_date)
    auction = SilentAuction.find(auction_id)
    auction.end_date = new_end_date
    if auction.save!
      "Auction #{auction_id} end_date changed to #{new_end_date}"
    else
      "ERROR!!! Auction end date not changed!"
    end
  end

  def assign_admin_role(username)
    user = User.find_by_username(username)
    user.admin = true
    if user.save!
      "#{username} HAS BEEN CHANGED TO ADMIN"
    else
      "ERROR! ROLE NOT CHANGED"
    end
  end

  def remove_admin_role(username)
    user = User.find_by_username(username)
    user.admin = false
    if user.save!
      "#{username} HAS BEEN CHANGED TO USER"
    else
      "ERROR! ROLE NOT CHANGED"
    end
  end

  def remove_bid_id(bid_id)
    if Bid.find(bid_id).destroy
      "BID HAS BEEN REMOVED"
    else
      "ERROR!!! BID NOT REMOVED"
    end
  end

  def remove_bid(username, auction_id)
    user_id = User.find_by_username(username)
    bid = Bid.where("user_id = ? AND silent_auction_id = ?", user_id, auction_id).first
    if bid.destroy
      "BID HAS BEEN REMOVED"
    else
      "ERROR!!! BID NOT REMOVED"
    end
  end

  def withdraw_bid_id(bid_id)
    bid = Bid.find(bid_id)
    bid.active = false
    if bid.save!
      "BID HAS BEEN WITHDRAWN"
    else
      "ERROR!!! BID NOT WITHDRAWN"
    end
  end

  def withdraw_bid(username, auction_id)
    user_id = User.find_by_username(username)
    bid = Bid.where("user_id = ? AND silent_auction_id = ?", user_id, auction_id).first
    bid.active = false
    if bid.save!
      "BID HAS BEEN WITHDRAWN"
    else
      "ERROR!!! BID NOT WITHDRAWN"
    end
  end

end