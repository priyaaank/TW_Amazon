Feature: Bid on an auction

  Background:
  Given there is a running auction as the following:
    | title        | description        | min_price | open | creator    | region | item_type      |
    | test title 2 | test description 1 | 200       | yes  | test-admin | AUS    | Silent Auction |
  And I'm logged in as a user

  @javascript
  Scenario: Place a bid
  When I place a bid as following:
    | auction title | bid amount |
    | test title 2  | 500        |
  Then my bid is recorded as:
    | amount | active |
    | 500    | yes    |

  @javascript
  Scenario: Multiple bidding
  When I place a bid as following:
    | auction title | bid amount |
    | test title 2  | 500        |
  Then I cannot bid for the same auction again