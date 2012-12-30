When /^I'm logged in as a user$/ do
  @user = User.create!(:username => 'test-user', :password => 'foobar', :admin => false)
  @user.region = Region.find_by_code 'AUS'
  @user.save!
  visit destroy_user_session_path
  visit new_dummy_session_path
  select 'test-user', :from => 'user[username]'
  fill_in 'user[password]', :with => @user.password
  click_button 'Login'
end

When /^I'm logged in as an admin$/ do
  @user = User.create!(:username => 'test-admin', :password => 'foobar', :admin => true)
  @user.region = Region.find_by_code 'AUS'
  @user.save!
  visit destroy_user_session_path
  visit new_dummy_session_path
  select 'test-admin', :from => 'user[username]'
  fill_in 'user[password]', :with => @user.password
  click_button 'Login'
end

When /^I logout from the system$/ do
  click_link 'user_menu'
  click_link 'Logout'
end

Then /^I can see my login status$/ do
  page.should have_content("Logged in as:")
  page.should have_content(@user.username)
end

Then /^I can see my account is admin$/ do
  page.should have_content("[ ADMIN ]")
end

Then /^I will be logged out$/ do
  current_path.should == root_path
end
