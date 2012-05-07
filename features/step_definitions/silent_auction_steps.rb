# DO WHAT WE CAN TO MAKE IT TRUE
Given /^a (?:valid|open) silent auction$/ do
  create_silent_auction
end

Given /^there are valid auctions as the following:$/ do |table|
  table.hashes.each do | hash |
    hash["open"] = (hash["open"] == "yes") ? true : false
    auction = SilentAuction.make!(:title => hash['title'], :description => hash['description'], :min_price => hash['min_price'])
    hash['active bids'].to_i.times do
      User.make!(:user).bids.create(:silent_auction_id => auction.id, :amount => hash['min_price'])
    end
    auction.open = hash["open"]
    auction.save!
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
    current_path.should == new_silent_auction_path
    find_field('End date').value.should == 2.weeks.from_now.to_formatted_s(:day_date_and_month)
    fill_in("silent_auction[title]", :with => hash['title'])
    fill_in("silent_auction[min_price]", :with => hash['min_price'])
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

When /^I close the auction$/ do
  within("tr#silentAuction_#{get(:silent_auctions).id}") do
    click_link 'close_auction'
    page.driver.browser.switch_to.alert.accept
  end
end

When /^I delete the auction$/ do
  within("tr#silentAuction_#{get(:silent_auctions).id}") do
    click_link 'delete_auction'
  end
end

When /^I choose to continue deleting$/ do
  click_link "delete_auction"
end

When /^choose to cancel deleting$/ do
  click_link "cancel_delete_auction"
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

Then /^it will have a minimum price$/ do
  verify_silent_auction_has_min_price get(:silent_auctions)
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
  page.should have_content('There are no running auctions')
end

Then /^I am told that no closed auctions exist$/ do
  page.should have_content('There are no closed auctions')
end

Then /^I cannot close the auction$/ do
  within("tr#silentAuction_#{get(:silent_auctions).id}") do
    page.should have_no_link("close_auction")
  end
end

Then /^I should see the confirmation page$/ do
  auction = get(:silent_auctions)
  current_path.should == confirm_delete_silent_auction_path(auction)
  page.should have_content("Are you sure you want to delete this auction?")
  page.should have_content(auction.title)
end

Then /^I should see the list of active bidders as following:$/ do |table|
  table.hashes.each do |hash|
    page.should have_content(hash["bidder"])
  end
end

Then /^the auction should be deleted$/ do
  auction = get(:silent_auctions)
  visit silent_auctions_path
  page.should have_no_content(auction.title)
  SilentAuction.find_by_title(auction.title).should == nil
end
