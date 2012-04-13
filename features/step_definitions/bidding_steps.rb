
When /^I bid on an auction at \$(\d+)$/ do |arg1|
  arg.hashes.each do | hash |

  visit new_silent_auction_path

  def create_bid
    #create_bid
    add :silent_auctions, bid.make!
  end

  create_bid

     #bid.make!(:bid => hash['$500']  )
    #bid.make!(bid: hash['$500'])
  #page.fill_in 'Name', :with => 'Bob'
  fill_in("bid[bid1]", :with => hash['$500'])

    #bid = {:bid1 => $500}


  end
end

Then /^my bid is recorded with the following:$/ do |table|
  table.hashes.each do | hash |

    bid.make!(username: hash['user 1'], bid: hash['$500'])
  end
end

When /^I have placed a bid$/ do
  bid.make!
end

Then /^I cannot bid for the same auction again$/ do
  bid.destroy
end