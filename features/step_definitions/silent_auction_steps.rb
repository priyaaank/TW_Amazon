# DO WHAT WE CAN TO MAKE IT TRUE
Given /^a (?:valid|open) silent auction$/ do
  create_silent_auction
end

Given /^there are valid auctions as the following:$/ do |table|
  table.hashes.each do | hash |
    hash["open"] = (hash["open"] == "yes") ? true : false
    @region = Region.find_by_code 'AUS'
    auction = SilentAuction.make!(:title => hash['title'], :description => hash['description'], :min_price => hash['min_price'], :region => @region)
    hash['active bids'].to_i.times do
      User.make!(:user).bids.create(:silent_auction_id => auction.id, :amount => hash['min_price'])
    end
    auction.open = hash["open"]
    auction.save!
  end
end

#TODO
Then(/^I see the following auction has been closed automatically$/) do |table|
  # table is a Cucumber::Ast::Table
  # look at the closed auction section, verify that the details that were passed through in the table are closed
end

Given /^there are no valid running auctions$/ do
  @region = Region.find_by_code 'AUS'
  SilentAuction.running(@region.timezone).destroy_all
end

Given /^there are no valid closed auctions$/ do
  SilentAuction.closed.destroy_all
end

# REAL USER ACTIONS
When /^I create a silent auction with the following:$/ do |table|
  @region = Region.find_by_code 'AUS'
  @category = Category.create(:category=>"Laptop")
  @category.save!
  @category = Category.create(:category=>"Misc")
  @category.save!
  table.hashes.each do | hash |
    visit new_silent_auction_path
    current_path.should == new_silent_auction_path
    find_field('End date').value.should == 2.weeks.from_now.in_time_zone(@region.timezone).to_s(:date_month_and_year)
    fill_in("silent_auction[title]", :with => hash['title'])
    fill_in("silent_auction[min_price]", :with => hash['min_price'])
    fill_in("silent_auction[description]", :with => hash['description'])
    fill_in("silent_auction[start_date]", :with => Date.today.to_s(:date_month_and_year))
    if(hash['category']!=nil)
      select(hash['category'],:from =>'silent_auction[category_id]')
    else
    select('Laptop',:from =>'silent_auction[category_id]')
    end
    click_button "submit_done"
  end
end

When /^the auction is open$/ do
  get(:silent_auctions).open = true
end

When /^the auction is closed$/ do
  get(:silent_auctions).open = false
end
When /^I view all running auctions$/ do
  visit silent_auctions_path
end

When /^I view all closed auctions$/ do
  visit closed_silent_auctions_path
end

When /^I view all expired auctions$/ do
  visit expired_silent_auctions_path
end

When /^I close the auction$/ do
  visit silent_auctions_path
  within("tr#silentAuction_#{get(:silent_auctions).id}") do
    click_button 'Manage'
    click_link 'close_auction'
    page.driver.browser.switch_to.alert.accept
  end
end

When /^I delete the auction$/ do
  visit silent_auctions_path
  within("tr#silentAuction_#{get(:silent_auctions).id}") do
    click_button 'Manage'
    click_link 'Delete'
  end
end

When /^I choose to continue deleting$/ do
  click_link "confirm_delete_auction_button"
end

When /^choose to cancel deleting$/ do
  click_link "cancel_delete_auction"
end

When(/^I change the auction details as follows:$/) do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end

When(/^I select to upload File with name <(.*)>$/) do |filename|
  attach_file(:silent_auction_photos_attributes_0_image, ::Rails.root.join('features', 'upload-files', filename))
end

When(/^I select to upload one more file with name <(.*)>$/) do |filename|
  click_link "Add another image"
  file_controls = page.all(:xpath, '//input[@type="file"]')
  attach_file(file_controls[1][:id], ::Rails.root.join('features', 'upload-files', filename))
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
  @region = Region.find_by_code 'AUS'
  within_table('runningAuctions') do
    page.all(:css,"tr.auction", :count => SilentAuction.running(@region.timezone).count)

    expected_order = table.raw.map {|titleRow| titleRow[0]}
    actual_order = page.all('p.itemTitle').collect(&:text)
    actual_order.should == expected_order
  end
end

Then /^I can see all closed auctions sorted by most recent first:$/ do |table|
  within_table('closedAuctions') do
    page.all(:css,"tr.auction", :count => SilentAuction.closed.count)

    expected_order = table.raw.map {|titleRow| titleRow[0]}
    actual_order = page.all('p.itemTitle').collect(&:text)
    actual_order.should == expected_order
  end
end

Then /^I can see all expired auctions sorted by most recent first:$/ do |table|
  @region = Region.find_by_code 'AUS'
  within_table('expiredAuctions') do
    page.all(:css,"tr.auction", :count => SilentAuction.expired(@region.timezone).count)

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
  visit silent_auctions_path
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

Then /^I can see the end date$/ do
  # TODO improve the effectiveness of asserting the dynamic end date
  # that should appear for each open auction on the listing page
  page.should have_content 'End date'
end

Then /^the auction should be deleted$/ do
  auction = get(:silent_auctions)
  visit silent_auctions_path
  page.should have_no_content(auction.title)
  SilentAuction.find_by_title(auction.title).should == nil
end

Then(/^I'm able to select both images$/) do
  file_controls = page.all(:xpath, '//input[@type="file"]')
  file_controls.size.should == 2
  file_controls[1].value.should == file_controls[0].value
end
When /^I view the auction details with title \"(.+)\"$/ do |sample_title|

  auction =  SilentAuction.find_by_title(sample_title)
  visit new_silent_auction_auction_message_path(auction)

end
When /^I add a comment to the auction with text \"(.+)\"$/ do |message|
  fill_in("auction_message[message]", :with => message)
  click_button "Submit"
end
Then /^I am able to view the message with text \"(.+)\"$/ do |message|
  page.should have_content message
end
When /^I choose the category "([^"]*)"$/ do |category_choice|
  visit silent_auctions_path
  select(category_choice,:from =>'search_category')
  click_button "search_done"
end

Then /^the auction details are changed$/ do
  pending
end
Then /^I am only able to view the following item$/ do |table|
  @region = Region.find_by_code 'AUS'
  within_table('runningAuctions') do
    expected_order = table.raw.map {|titleRow| titleRow[0]}
    actual_order = page.all('p.itemTitle').collect(&:text)
    actual_order.should == expected_order
    end
end