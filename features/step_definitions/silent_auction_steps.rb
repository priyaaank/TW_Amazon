# DO WHAT WE CAN TO MAKE IT TRUE
Given /^a valid silent auction$/ do
  create_silent_auction
  #ap get(:silent_auctions)
end


# REAL USER ACTIONS
When /^I create a silent auction with the following:$/ do |table|
  table.hashes.each do | hash |
    create_silent_auction_from_hash hash
  end
 end

# VALIDATE HOWEVER WE MUST
Then /^a valid silent auction is created with the following:$/ do |table|
  table.hashes.each do | hash |
      hash["open"] = (hash["open"] == "yes") ? true : false

      SilentAuction.where(hash).count.should == 1
  end
end

Then /^it will have a title$/ do
  verify_silent_auction_has_title get(:silent_auctions)
end

Then /^it will have a description$/ do
  verify_silent_auction_has_description get(:silent_auctions)
end
