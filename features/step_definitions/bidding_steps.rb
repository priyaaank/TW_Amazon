
#When /^I bid on an auction at $500 $/ do
 # get(:silent_auctions).bid = $500
#end

When /^I bid on an auction at \$(\d+)$/ do |arg1|
  arg.hashes.each do | hash |

    bid.make!(:bid => hash['$500']  )

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
  SilentAuction.destroy
end