Feature: View auction listing

Scenario: View all auctions
	Given there are valid running and closed silent auctions

    When I'm logged in as an admin
	And I view all auctions
	Then I can see all auctions
    And I can see running auctions and closed auctions separately

    When I'm logged in as a user
    And I view all auctions
    Then I can see all auctions
    And I can see running auctions and closed auctions separately
	
Scenario: view all running auctions
	Given there are valid auctions with the following:
      | title        | description        | min_price | open |
      | test title 1 | test description 1 | 100       | yes |
      | test title 2 | test description 2 | 200       | yes |
      | test title 3 | test description 3 | 300       | no |
      | test title 4 | test description 4 | 400       | no |

  When I'm logged in as an admin
  And I view all running auctions
	Then I can see all running auctions sorted by most recent first:
      | test title 2 |
      | test title 1 |

Scenario: view all closed auctions
    Given there are valid auctions with the following:
      | title        | description        | min_price | open |
      | test title 1 | test description 1 | 100       | yes |
      | test title 2 | test description 2 | 300       | no |
      | test title 3 | test description 3 | 400       | no |

  	When I view all closed auctions
  	Then I can see all closed auctions sorted by most recent first:
      | test title 3 |
      | test title 2 |
	
Scenario: no running auctions to see
	Given there are no valid running auctions
	When I view all running auctions
	Then I am told that no auctions are currently running

Scenario: no closed auctions to see
    Given there are no valid closed auctions
    When I view all closed auctions
    Then I am told that no closed auctions exist