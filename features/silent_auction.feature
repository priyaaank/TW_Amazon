Feature: silent auction

Scenario: define a silent auction
	Given a valid silent auction
	Then it will have a title
	And it will have a description
	
Scenario: create silent auction
	When I create a silent auction with the following:
	| title | description | 
	| sample title | this is my description | 
	Then a valid silent auction is created with the following:
	| title | description | open |
	| sample title | this is my description | yes |
	
	
Feature: navigation	
	when creating a silent auction
	and I save and return
	then I should be on the 'create silent auction' page
	
	when creating a silent auction
	and I save and exit
	then I should be on the 'listings' page
	
