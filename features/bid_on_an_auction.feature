Feature: Bid on an auction

Scenario: define bid
	Given an open silent auction
	When I bid on an auction at $500
	Then my bid is recorded with the following:
	| user name | amount |
	| user 1 | $500 |
	
Scenario: multiple bidding
	Given an open silent auction
	When I have placed a bid
	Then I cannot bid for the same auction again