Feature: find running auction

Scenario: define running auction
	Given a valid silent auction
	When the auction is open
	Then the auction is running
	
Scenario: define an auction that is not running	
	Given a valid silent auction
	When the auction is closed
	Then the auction is not running
	
Scenario: view all active auctions
	Given there are valid auctions with the following:
	| title | description | open |
	| test title 1 | test description 1 | yes |
	| test title 2 | test description 2 | yes |
	| test title 3 | test description 3 | no |
	
	When I view all auctions
	Then I can see all the auctions
    And the auctions are sorted in open and closed order
	And then sorted by most recent first
	
Scenario: sort auctions
	Given there are valid auctions
	When I view all auctions
	Then I can see the auctions sorted in alphabetical order
	
Scenario: no auctions to see
	Given there are no valid auctions
	When I view all auctions
	Then I am told that no auctions are currently going