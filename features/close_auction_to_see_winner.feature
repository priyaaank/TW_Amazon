Feature: Close auction to see winner

  Background:
    Given there is a running auction as the following:
      | title        | description        | min_price | region | open |
      | test title 1 | test description 1 | 200       | AUS    | yes  |

  @javascript
  Scenario: Admin close auction
    Given there is at least one bid placed for the auction
    And I'm logged in as an admin
    When I close the auction
    Then the auction is closed
    And no more bids are allowed

  @javascript
  Scenario: Auction with no bid
    Given I'm logged in as an admin
    When there are no bids placed for the auction
    Then I cannot close the auction

  @javascript
  Scenario: View auction winner
    Given there are bids placed for the auction as following:
      | user | bid amount |
      | user_1 | 500.99 |
      | user_2 | 200.5 |
      | user_3 | 550.00 |
      | user_4 | 210.45 |
    And I'm logged in as an admin
    When I close the auction
    Then I can see the winner is "user_3"
    And I can see the winning bid is "$ 550.0"
