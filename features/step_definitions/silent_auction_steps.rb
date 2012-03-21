#DO WHAT WE CAN TO MAKE IT TRUE
Given /^a valid silent auction$/ do
  create_silent_auction
end


#REAL USER ACTIONS
When /^I create a silent auction with the following:$/ do |table|
  table.hashes.each do | hash |
    {'title' => 'sample title', 'description' => 'this is my description'}
  end
 end


#VALIDATE HOWEVER WE MUST
Then /^a valid silent auction is created with the following:$/ do |table|
  table.hashes.each do | hash |
      {'title' => 'sample title', 'description' => 'this is my description', 'open' => true }
  end
end

Then /^it will have a title$/ do
  verify_silent_auction_has_title get(:silent_auction)
end

Then /^it will have a description$/ do
  verify_silent_auction_has_description get(:silent_auction)
end
