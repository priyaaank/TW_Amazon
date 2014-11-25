require_relative '../../spec/spec_helper'

def user_creation(username, password, role, region = nil)
  @user = User.create!(:username => username, :password => password, :admin => role)
  @user.region = Region.find_by_code 'AUS' unless region.nil?
  @user.save!
end

def login (username, password, role, region)
  user_creation(username, password, role, region)
  visit new_user_session_path
  select username, :from => 'user[username]'
  fill_in 'user[password]', :with => password
  click_button 'Login'
end

Given /^I'm logged in as a new user$/ do
  login('test-user', 'foobar', false, nil)
end

When /^I select my region$/ do
  select 'USA', :from => 'user[region]'
end

When /^I'm logged in as a user$/ do
  login 'test-user', 'foobar', false, 'AUS'
end

When /^I'm logged in as an admin$/ do
  login 'test-admin', 'foobar', true, 'AUS'
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
