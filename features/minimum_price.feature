Feature: minimum price

Scenario: set a minimum price
Given I am admin
When I create a silent auction
Then I set a minimum price
