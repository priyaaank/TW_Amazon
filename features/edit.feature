Feature: edit

  Background:
    Given I'm logged in as an admin
    And there are valid auctions as the following:
      | title | description | min_price | end date | image |
      | title 1 | description 1 | 300 | 23-05-2012 | image1.jpg |


@javascript
Scenario: edit silent auctions

Given there are no bids placed on that auction
When I need to change the details of the auction
Then I change details of the auction as following:
| title | description | min_price | end date | image |
| MacBook Air | In good condition | 300 | 23 - 05-2012 | macbook.jpg |
