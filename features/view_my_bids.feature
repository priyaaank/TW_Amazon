Feature: View my bids 

    Background:
	Given I'm logged in as an admin
	And I create a silent auction with the following:
      | title                | description        | min_price | open |
      | Apple MacBook Pro 15 | test description 1 | 300       | yes  |
      | Apple MacBook Air 11 | test description 2 | 400       | yes  |
      | imac                 | test description 3 | 100       | no   |
      | mac mini             | test description 4 | 450       | no   |

    @javascript
    Scenario: View my bids
	Given I'm logged in as a user
	And I have bid on following auctions:
      | title                | description        | my bid |
      | Apple MacBook Pro 15 | test description 1 | 3001   |
      | Apple MacBook Air 11 | test description 2 | 500    |
	When I view my page
	Then I can see all the running auctions that I have placed bids sorted by the most recent first:
      | title                | description        | min_price | my bid | open |
      | Apple MacBook Air 11 | test description 2 | 400       | 500    | yes  |
      | Apple MacBook Pro 15 | test description 1 | 300       | 3001   | yes  |
