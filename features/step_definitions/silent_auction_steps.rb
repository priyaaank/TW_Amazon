# DO WHAT WE CAN TO MAKE IT TRUE
Given /^a valid silent auction$/ do
  create_silent_auction
  #ap get(:silent_auctions)
end

Given /^there are valid auctions with the following:$/ do |table|
  table.hashes.each do | hash |
    SilentAuction.create!(:title => hash['title'], :description => hash['description'], :open => (hash['open'] == 'yes'? true : false))
  end
end

Given /^there are no valid running auctions$/ do
  SilentAuction.running.destroy_all
end

Given /^there are no valid closed auctions$/ do
  SilentAuction.closed.destroy_all
end

# REAL USER ACTIONS
When /^I create a silent auction with the following:$/ do |table|
  table.hashes.each do | hash |
    create_silent_auction_from_hash hash
  end
end

When /^the auction is open$/ do
  get(:silent_auctions).open = true
end

When /^the auction is closed$/ do
  get(:silent_auctions).open = false
end

When /^I view all auctions$/ do
  visit silent_auctions_path
end

When /^I view all running auctions$/ do
  visit silent_auctions_path
end

When /^I view all closed auctions$/ do
  visit silent_auctions_path
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

Then /^the auction is running$/ do
  get(:silent_auctions).open?.should == true
end

Then /^the auction is not running$/ do
  get(:silent_auctions).open?.should == false
end

Then /^I can see all the running auctions$/ do
  within_table('runningAuctions') do

  end
end

Then /^I can see all the closed auctions$/ do
  within_table('closedAuctions') do

  end
end

Then /^the auctions are sorted by most recent first$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I am told that no auctions are currently running$/ do
  page.should have_content('There is no running auction')
end

Then /^I am told that no closed auctions exist$/ do
  page.should have_content('There is no closed auction')
end
