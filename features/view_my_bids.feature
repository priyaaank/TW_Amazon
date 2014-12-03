Feature: View my bids 

    Background:
	Given I'm logged in as an admin
	And I create a silent auction with the following:
      | title                | description        | min_price | open |
      | Apple MacBook Pro 15 | test description 1 | 300       | yes  |
      | Apple MacBook Air 11 | test description 2 | 400       | yes  |
      | imac                 | test description 3 | 100       | yes  |
      | mac mini             | test description 4 | 450       | yes  |
    And I logout from the system

    @javascript
    Scenario: View my bids
	Given I'm logged in as a user
	And I have bid on following auctions:
      | title                | description        | my bid |
      | Apple MacBook Pro 15 | test description 1 | 3001   |
      | Apple MacBook Air 11 | test description 2 | 500    |
      | imac                 | test description 3 | 110    |
      | mac mini             | test description 4 | 460    |
    And the following auctions were closed:
      | title                |
      | imac                 |
      | mac mini             |
	When I view my auctions page
	Then I can see all the running auctions that I have placed bids:
      | title                | description        | min_price | my bid | open |
      | Apple MacBook Air 11 | test description 2 | 400       | 500    | yes  |
      | Apple MacBook Pro 15 | test description 1 | 300       | 3001   | yes  |
    And I can see all the closed auctions that I have placed bids:
      | title                | description        | min_price | my bid | open |
      | mac mini             | test description 4 | 450       | 460    | no   |
      | imac                 | test description 3 | 100       | 110    | no   |
