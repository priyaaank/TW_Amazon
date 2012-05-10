Feature: View auction listing

  Background:
  Given there are valid auctions as the following:
    | title     | description        | min_price | active bids | open |
    | auction 1 | test description 1 | 200       | 0           | yes  |
    | auction 2 | test description 2 | 400       | 0           | yes  |
    | auction 3 | test description 3 | 500       | 1           | no  |
    | auction 4 | test description 4 | 100       | 1           | no  |
    | auction 5 | test description 3 | 500       | 0           | no  |
    | auction 6 | test description 4 | 100       | 0           | no  |

  @javascript
  Scenario: View running auctions
	Given I'm logged in as an admin
	When I view all running auctions
    And I can see all running auctions sorted by most recent first:
      | auction 2 |
      | auction 1 |
    And I can see the end date

  @javascript
  Scenario: View closed auctions
    Given I'm logged in as an admin
    When I view all closed auctions
    And I can see all closed auctions sorted by most recent first:
      | auction 4 |
      | auction 3 |
    And I can see the end date

  @javascript
  Scenario: View expired auctions
    Given I'm logged in as an admin
    When I view all expired auctions
    And I can see all expired auctions sorted by most recent first:
      | auction 6 |
      | auction 5 |
    And I can see the end date

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
