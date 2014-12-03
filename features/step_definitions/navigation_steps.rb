When /^I create a silent auction$/ do
  @category = Category.create(:category=>"Laptops")
  @category.save!
  visit new_silent_auction_path
  fill_in "silent_auction[title]", :with => 'sample title'
  fill_in "silent_auction[min_price]", :with => 1
  fill_in "silent_auction[description]", :with => 'sample description'
  fill_in 'silent_auction[start_date]', :with  => Date.today.to_s
  select('Laptops',:from =>'silent_auction[category_id]')
end

When /^choose to save and continue creating$/ do
  click_button 'submit_continue'  # using button id
end

When /^choose to save and return$/ do
  click_button 'submit_done'  # using button id
end

When /^I am in the 'create silent auction' page$/ do
  visit new_silent_auction_path
end

When /^choose to cancel creating a new auction$/ do
  click_link "Back to Listing"
end

Then /^I should be on the 'create silent auction' page$/ do
  current_path.should == new_silent_auction_path
end

Then /^I should be on the 'list my items' page$/ do
  current_path.should == list_my_items_user_path(@user)
end

Then /^I should be on the 'listings' page$/ do
  current_path.should == silent_auctions_path
end


And /^I should (?:be on|go back to) 'running_auctions' page$/ do
  current_path.should == silent_auctions_path
end

Then /^I can see the end date set as 2 weeks from now$/ do
    @region = Region.find_by_code 'AUS'
    find_field('End date').value.should == 2.weeks.from_now.in_time_zone(@region.timezone).to_s(:date_month_and_year)
end
