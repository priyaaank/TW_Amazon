Feature: Navigation

Scenario: create silent auction
	When I create a silent auction
	And choose to save and continue creating
  	Then I should be on the 'create silent auction' page

Scenario: create silent auction
  	When I create a silent auction
  	And choose to save and return
  	Then I should be on the 'listings' page

Scenario: create silent auction
	When I am in the 'create silent auction' page
	And choose to cancel creating a new auction
	Then I should go back to 'listings' page