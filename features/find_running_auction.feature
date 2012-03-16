Feature: find running auction

Scenario: define running auction
	given a valid silent auction
	when the auction is open
	then the auction is running
	
	given a valid silent auction
	then the auction is closed
	then the auction is not running
	
Scenario: view all active auctions
	given there are valid auctions:
	| title | description | minimum price | open |
	| 3 | 3 | 300.00 | 2 * yes, 1 * no |
	when i view all auctions
	then I can see the following auctions:
	| title | description | minimum price |
	| 3 | 3 | 300.00 | 2 * yes |
	
Scenario: no auctions to see
	given there are no valid auctions
	when  view all auctions
	then I am told that no auctions are currently going