Feature: Filter Auctions

Background:
Given I'm logged in as an admin
And I create a silent auction with the following:
| title                | description        | min_price | open | category |
| Apple MacBook Pro 15 | test description 1 | 300       | yes  | Laptop   |
| Apple MacBook Air 11 | test description 2 | 400       | yes  | Laptop   |
| imac                 | test description 3 | 100       | yes  | Misc     |
| mac mini             | test description 4 | 450       | yes  | Laptop   |

@javascript
Scenario:  Filter Running Auctions List to misc item
Given I'm logged in as a user
And I choose the category "Misc"
Then I am only able to view the following item
  | imac                 |
