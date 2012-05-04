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





	