require_relative '../../spec/spec_helper'

def login (username, admin)
  resize_window
  @user = User.create!(:username => username, :password => 'foobar', :admin => admin)
  @user.region = Region.find_by_code 'AUS'
  @user.save!
  visit new_user_session_path
  select username, :from => 'user[username]'
  fill_in 'user[password]', :with => @user.password
  click_button 'Login'
end

Given /^I'm logged in as a new user$/ do
  resize_window
  @user = User.create!(:username => 'test-user', :password => 'foobar', :admin => false)
  @user.save!
  Region.make!(:usa)
  visit new_user_session_path
  select 'test-user', :from => 'user[username]'
  fill_in 'user[password]', :with => @user.password
  click_button 'Login'
end

When /^I select my region$/ do
  select 'USA', :from => 'user[region]'
end

When /^I'm logged in as a user$/ do
  login 'test-user', false
end

When /^I'm logged in as an admin$/ do
  login 'test-admin', true
end

When /^I logout from the system$/ do
  #TODO: fix the logout
  visit "/admin/logout"
  #save_screenshot('logout.png', :full => true)
end

Then /^I can see my login status$/ do
  page.should have_content("Logged in as:")
  page.should have_content(@user.username)
end

Then /^I can see my account is admin$/ do
  page.should have_content("[ ADMIN ]")
end

Then /^I will be logged out$/ do
  #TODO: fix the redirect
  current_path.should == "/test-users/login"
  #save_screenshot('redirect.png', :full => true)
end

Then /^I can see my region$/ do
  page.should have_content("USA")
end
