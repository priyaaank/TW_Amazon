# DO WHAT WE CAN TO MAKE IT TRUE
Given /^a (?:valid|open) silent auction$/ do
  create_silent_auction
end

Given /^there are valid auctions with the following:$/ do |table|
  table.hashes.each do | hash |
    hash["open"] = (hash["open"] == "yes") ? true : false
    SilentAuction.make!(:title => hash['title'], :description => hash['description'], :open => hash['open'])
  end
end

Given /^there are valid running and closed silent auctions$/ do
  5.times do
    SilentAuction.make!
  end
  3.times do
    SilentAuction.make!(:open => false)
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
    visit new_silent_auction_path
    fill_in("silent_auction[title]", :with => hash['title'])
    fill_in("silent_auction[description]", :with => hash['description'])
    click_button "submit_done"
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

Then /^I can see all auctions$/ do
  page.find(:css,"tr.auction", :count => SilentAuction.count)
end

Then /^I can see running auctions and closed auctions separately$/ do
  page.should have_css('table#runningAuctions')
  page.should have_css('table#closedAuctions')
end

Then /^I can see all running auctions sorted by most recent first:$/ do |table|
  within_table('runningAuctions') do
    page.find(:css,"tr.auction", :count => SilentAuction.running.count)

    expected_order = table.raw.map {|titleRow| titleRow[0]}
    actual_order = page.all('p.itemTitle').collect(&:text)
    actual_order.should == expected_order
  end
end

Then /^I can see all closed auctions sorted by most recent first:$/ do |table|
  within_table('closedAuctions') do
    page.find(:css,"tr.auction", :count => SilentAuction.closed.count)

    expected_order = table.raw.map {|titleRow| titleRow[0]}
    actual_order = page.all('p.itemTitle').collect(&:text)
    actual_order.should == expected_order
  end
end

Then /^I am told that no auctions are currently running$/ do
  page.should have_content('There is no running auction')
end

Then /^I am told that no closed auctions exist$/ do
  page.should have_content('There is no closed auction')
end
Given /^an open silent auction$/ do
  pending
end
