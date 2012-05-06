Feature: Withdraw bid before auction close

  Background:
    Given I'm logged in as a user
    And there is a running auction as the following:
      | title        | description        | min_price |
      | test title 1 | test description 1 | 200       |

    And I place a bid as following:
      | auction title | bid amount |
      | test title 1  | 500        |

  @javascript
  Scenario: Withdraw bid
	When I withdraw my bid
	Then my bid is marked as withdrawn
    And I cannot bid for the same auction again
