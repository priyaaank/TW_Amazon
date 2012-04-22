Feature: cancel bid before close

Scenario: remove bid
	Given an open silent auction
	Given I have a bid on the auction
	When I withdraw my bid
	Then my bid is marked as withdrawn
    And I cannot bid for the same auction again
