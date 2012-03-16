Feature: silent auction

Scenario: define a silent auction
	Given a silent auction
	When it is valid
	Then it will have a title
	And it will have a description
	And  it will have a minimum price
	
Scenario: create silent auction
	When I create a silent auction with the following:
	| title | description | minimum price |
	| sample title | this is my description | 300.00 |
	Then a valid silent auction is created with the following:
	| title | description | minimum price | open |
	| sample title | this is my description | 300.00 | yes |
	