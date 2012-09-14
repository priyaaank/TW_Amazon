Given /^I have bid on following auctions:$/ do |table|
  visit silent_auctions_path
  table.hashes.each do |hash|
    auction = SilentAuction.find_by_title(hash['title'])
    within("td#bid_for_auction_#{auction.id}") do
      fill_in 'bid_amount', :with => hash['my bid']
      click_button 'Place Bid'
    end
  end
end

When /^I view my auctions page$/ do
  user = User.find_by_username("test-user")
  visit user_path(user)
end

When /^the following auctions were closed:$/ do |table|
  table.hashes.each do |hash|
    auction = SilentAuction.find_by_title(hash['title'])
    auction.close
  end
end

Then /^I can see all the running auctions that I have placed bids:$/ do |table|
  within_table('currentBids') do
    table.hashes.each do |hash|
      page.should have_content(hash['title'])
      page.should have_content(hash['description'])
      page.should have_content(number_to_currency(hash['my bid']))
    end
  end
end

Then /^I can see all the closed auctions that I have placed bids:$/ do |table|
  within_table('closedBids') do
    table.hashes.each do |hash|
      page.should have_content(hash['title'])
      page.should have_content(hash['description'])
      page.should have_content(number_to_currency(hash['my bid']))
    end
  end
end