Feature: edit

  Background:
    Given I'm logged in as an admin
    And there are valid auctions as the following:
      | title   | description   | min_price | end date   | image      | active bids |
      | title 1 | description 1 | 300       | 23-05-2012 | image1.jpg | 0           |


@javascript
Scenario: edit silent auctions

  When I change the auction details as follows:
    | title       | description       | min_price | end date   | image       |
    | MacBook Air | In good condition | 300       | 23-05-2012 | macbook.jpg |
  Then the auction details are changed