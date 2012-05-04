Feature: close auction

Scenario: close auction

Given I am a logged in admin
Given an open silent auction
And there is at least one bid
When I close the auction
Then the auction is closed
And no more bids are allowed