Feature: Delete Auction

  Background:
    Given there is a running auction as follows:
      | title        | description        | min_price | open | region |
      | test title 1 | test description 1 | 200       | yes  | AUS    |
    And there are bids placed for the auction as follows:
      | user | bid amount |
      | user_1 | 500.99 |
      | user_2 | 200.5 |
      | user_3 | 550.00 |
      | user_4 | 210.45 |
    And  I'm logged in as an admin

  @javascript
  Scenario: Delete an auction
    When I have chosen to delete an auction
    Then I am on the confirm deletion page
    And I should see the list of active bidders as following:
      | bidder|
      | user_1|
      | user_2|
      | user_3|
      | user_4|
    When I confirm deletion of the auction
    Then the auction should be deleted
    And I should go back to 'running_auctions' page


#  @javascript
 # Scenario: Cancel Delete auction
 #   When I delete the auction
 #   And choose to cancel deleting
 #   Then I should go back to 'running_auctions' page
