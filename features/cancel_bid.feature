Feature: cancel bid before close

Scenario: remove bid
	Given an open silent auction
	Given I have a bid on the auction
	When I withdraw my bid
	Then my bid is marked as withdrawn
	
Scenario: withdraw bid
	Given an open silent auction
	When I have withdrawn from that bid
	Then I cannot bid for the same auction
	
	

