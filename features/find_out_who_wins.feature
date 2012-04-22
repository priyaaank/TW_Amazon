Feature: find out who wins
	
Scenario: can see the winning bid
    Given an open silent auction
	Given the following <bids> have been placed
	| bids |
	| 1 |
	| 100 |
	| 50 |
	When I choose to close the auction
	Then I can see the winning bid of a '100' dollars
