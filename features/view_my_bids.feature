Feature: my account

Scenario: View my bids
Given that I have bid on following auctions:
| title | description | minimum price | my bid | open |
| Apple MacBook Pro 15" | test description 1 | 300 | 3001 | yes |
| Apple MacBook Air 11" | test description 2 | 400 | 500 | yes|
| imac | test description 3 | 100 | 101 | no |
| mac mini | test description 4 | 450 | 500 | no |

When I view my page
Then I can see all the running auctions that I have placed bids sorted by the most recent first:
| title | description | minimum price | my bid | open |
| Apple MacBook Air 11" | test description 2 | 400 | 500 | yes|
| Apple MacBook Pro 15" | test description 1 | 300 | 3001 | yes |
