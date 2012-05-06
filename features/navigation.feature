Feature: Navigation

  @javascript
  Scenario: create silent auction
    Given I'm logged in as an admin
    When I create a silent auction
    And choose to save and continue creating
    Then I should be on the 'create silent auction' page

  @javascript
  Scenario: create silent auction
    Given I'm logged in as an admin
    When I create a silent auction
    And choose to save and return
    Then I should be on 'listings' page

  @javascript
  Scenario: create silent auction
    Given I'm logged in as an admin
    When I am in the 'create silent auction' page
    And choose to cancel creating a new auction
    Then I should go back to 'listings' page
