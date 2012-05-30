Feature: Delete Auction

  Background:
    Given there is a running auction as the following:
      | title        | description        | min_price |
      | test title 1 | test description 1 | 200       |
    And there are bids placed for the auction as following:
      | user | bid amount |
      | user_1 | 500.99 |
      | user_2 | 200.5 |
      | user_3 | 550.00 |
      | user_4 | 210.45 |
    And  I'm logged in as an admin

  @javascript
  Scenario: Delete an auction
    When I delete the auction
    Then I should see the confirmation page
    And I should see the list of active bidders as following:
      | bidder                  |
      | user_1@thoughtworks.com |
      | user_2@thoughtworks.com |
      | user_3@thoughtworks.com |
      | user_4@thoughtworks.com |
    When I choose to continue deleting
    Then the auction should be deleted

  @javascript
  Scenario: confirm delete auction
    When I delete the auction
    And I choose to continue deleting
    Then I should go back to 'running_auctions' page

  @javascript
  Scenario: cancel delete auction
    When I delete the auction
    And choose to cancel deleting
    Then I should go back to 'running_auctions' page