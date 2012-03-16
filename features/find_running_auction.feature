Feature: find running auction

Scenario: define running auction
		  Given	a valid silent auction
		  When	the auction is open
		  Then	the auction is running
		
		  Given	a valid silent auction
		  When the auction is closed
		  Then the auction is not running
		
Scenario: view all active auctions
		  Given	there are valid auctions
		  | title | description | minimum price | open |
		  |  3   |   3   | 300.00 | 2 x yes, 1x no |
		  When I view all auctions
		  T	I can see the following auctions
		  | title | description | minimum price |
		  |  3   |   3   | 300.00 | 2 x yes |
		
Scenario: no auctions to see
		  Given	there are no valid auctions
		  When I view all auctions
		  Then I am told that no auctions are currently going 


		
		