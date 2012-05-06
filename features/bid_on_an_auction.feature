Feature: Bid on an auction

  Background:
  Given there is a running auction as the following:
    | title        | description        | min_price |
    | test title 1 | test description 1 | 200       |
  And I'm logged in as a user

  @javascript
  Scenario: Place a bid
  When I place a bid as following:
    | auction title | bid amount |
    | test title 1  | 500        |
  Then my bid is recorded as:
    | amount | active |
    | 500    | yes    |

  @javascript
  Scenario: Multiple bidding
  When I place a bid as following:
    | auction title | bid amount |
    | test title 1  | 500        |
  Then I cannot bid for the same auction again