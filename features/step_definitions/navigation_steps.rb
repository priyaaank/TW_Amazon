When /^I create a silent auction$/ do
  visit new_silent_auction_path
  fill_in "silent_auction[title]", :with => 'sample title'
  fill_in "silent_auction[description]", :with => 'sample description'
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

Then /^I should (?:be on|go back to) 'listings' page$/ do
  current_path.should == silent_auctions_path
end

When /^I'm logged in as a user$/ do
  @user = User.create!(:username => 'test-user', :password => 'foobar')
  visit destroy_user_session_path
  visit new_dummy_session_path 
  select 'test-user', :from => 'user[username]'
  fill_in 'user[password]', :with => @user.password
  click_button 'Login'
end

When /^I'm logged in as an admin$/ do
  @user = User.create!(:username => 'test-admin', :password => 'foobar', :admin => true)
  visit destroy_user_session_path
  visit new_dummy_session_path 
  select 'test-admin', :from => 'user[username]'
  fill_in 'user[password]', :with => @user.password
  click_button 'Login'
end
