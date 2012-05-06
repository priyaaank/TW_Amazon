Feature: View auction listing

    Background:
    Given there are valid auctions as the following:
    | title        | description        | min_price | active bids | open |
    | test title 1 | test description 1 | 200       | 0           | yes |
    | test title 2 | test description 2 | 400       | 0           | yes |
    | test title 3 | test description 3 | 500       | 1           | no |
    | test title 4 | test description 4 | 100       | 1           | no |

    @javascript
    Scenario: View all auctions
	Given I'm logged in as a user
	When I view all auctions
    Then I can see running auctions and closed auctions separately

    And I can see all running auctions sorted by most recent first:
    | test title 2 |
    | test title 1 |

    And I can see all closed auctions sorted by most recent first:
    | test title 4 |
    | test title 3 |

    @javascript
    Scenario: No running auctions to see
    Given I'm logged in as a user
	And there are no valid running auctions
	When I view all running auctions
	Then I am told that no auctions are currently running

    @javascript
    Scenario: No closed auctions to see
    Given I'm logged in as a user
    And there are no valid closed auctions
    When I view all closed auctions
    Then I am told that no closed auctions exist