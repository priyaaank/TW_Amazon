Feature: ind out who wins

Scenario: cannot see the winning bid
	Given an open auction
	Then I cannot see the winning bid
	
Scenario: can see the winning bid	
	Given the following <bids> have been placed
	| bids |
	| 1 |
	| 100 |
	| 50 |
	When I choose to close the auction
	Then I can see the winning bid of a '100' dollars
	
	