Given /^there is a running auction as the following:$/ do |table|
  table.hashes.each do | hash |
    hash["open"] = (hash["open"] == "yes") ? true : false
    hash['region'] ||= 'AUS'
    auction = SilentAuction.make!(:title => hash['title'], :description => hash['description'], :min_price => hash['min_price'], :open => hash["open"], :creator => hash["creator"], :region => Region.find_by_code(hash["region"]), :start_date => Time.now.to_date, :end_date => Time.now.to_date + 2.days)
    add :silent_auctions, auction
  end
end

Given /^there are bids placed for the auction as following:$/ do |table|
  table.hashes.each do | hash |
    User.make!(:user, :username => hash['user']).bids.create(:silent_auction_id => get(:silent_auctions).id, :amount => hash['bid amount'])
  end
end

Given /^there is at least one bid placed for the auction$/ do
  auction = get(:silent_auctions)
  User.make!(:user).bids.create(:silent_auction_id => auction.id, :amount => auction.min_price)
end

When /^there are no bids placed for the auction$/ do
  get(:silent_auctions).bids.destroy_all
end

When /^I place a bid as following:$/ do |table|
  visit silent_auctions_path
  table.hashes.each do |hash|
    auction = SilentAuction.find_by_title(hash['auction title'])
    add :silent_auctions, auction
    within("td#bid_for_auction_#{auction.id}") do
      fill_in 'bid_amount', :with => hash['bid amount']
      click_button 'Place Bid'
    end
  end
end

When /^I withdraw my bid$/ do
  visit silent_auctions_path
  within("td#bid_for_auction_#{get(:silent_auctions).id}") do
    click_link 'Withdraw Bid'
    page.driver.browser.switch_to.alert.accept
  end
end

Then /^my bid is recorded as:$/ do |table|
  table.hashes.each do | hash |
    hash["active"] = (hash["active"] == "yes") ? true : false
    hash["silent_auction_id"] = get(:silent_auctions).id
    hash["user_id"] = @user.id
    Bid.where(hash).count.should == 1
  end
end

Then /^I cannot bid for the same auction again$/ do
  visit silent_auctions_path
  within("td#bid_for_auction_#{get(:silent_auctions).id}") do
    page.should have_no_button("Place Bid")
    page.should have_no_content("bid_amount")
  end
end

Then /^my bid is marked as withdrawn$/ do
  within("td#bid_for_auction_#{get(:silent_auctions).id}") do
    page.should have_no_link("Withdraw Bid")
    page.should have_content("WITHDRAWN")
  end
end

Then /^no more bids are allowed$/ do
  visit silent_auctions_path
  page.should have_no_content("tr#silentAuction_#{get(:silent_auctions).id}")
  visit closed_silent_auctions_path
  within("tr#silentAuction_#{get(:silent_auctions).id}") do
    page.should have_no_button("Place Bid")
  end
end

Then /^I can see the winner is "([^"]*)"$/ do |winner|
  within("tr#silentAuction_#{get(:silent_auctions).id}") do
    page.should have_content(winner)
  end
end

Then /^I can see the winning bid is "([^"]*)"$/ do |winningBid|
  within("tr#silentAuction_#{get(:silent_auctions).id}") do
    page.should have_content(winningBid)
  end
end
