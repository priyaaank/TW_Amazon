Feature: pagination

Scenario: results on first page

Given I'm logged in as admin or a user
Given I have three closed auctions
When I view all closed auctions
Then I should see "closed auction 1"
And I should see "closed auction 2"
And I should see "closed auction 3"

Scenario: page links

Given I'm logged in as admin or a user
Given I have <count> closed auctions 
When I view all closed auctions from <page>
Then I should see a link to page <target page> as following:

| count | page | target page |
| 6 | 1 | 2 |
| 6 | 2 | 1 |
| 15 | 1 | 2 |
| 15 | 1 | 3 |
| 15 | 2 | 1 |
| 15 | 2 | 3 |
| 15 | 3 | 1 |
| 15 | 3 | 2 |

Scenario: page links for current page

Given I have <count> closed auctions
When I view all closed auctions from page <page>
Then I should see a disabled link to page <page> as following:
| count | page |
| 6 | 1 |
| 6 | 2 |
| 15 | 1 |
| 15 | 2 |
| 15 | 3 |

Scenario: next page links

Given I have <count> closed auctions
When I view all closed auctions from page <page>
Then I should see a link to "Next page"

When I click on "Next page"
Then I should be n page <next page> as follwing:
| count | page | next page |
| 6 | 1 | 2 |
| 15 | 1 | 2 |
| 15 | 2 | 3 |

Scenario: next page links on last page

Given I have <count> closed auctions
When I view all closed auctions from page <page>
Then I should see a disabled paginations link "Next page" as following:
| count | page |
| 6 | 2 |
| 15 | 3 |




