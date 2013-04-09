Feature: silent auction

    Scenario: Define a silent auction
    Given a valid silent auction
    Then it will have a title
    And it will have a description
    And it will have a minimum price

    Scenario: Define running auction
    Given a valid silent auction
    When the auction is open
    Then the auction is running

    Scenario: Define an auction that is not running
    Given a valid silent auction
    When the auction is closed
    Then the auction is not running

    @javascript
    Scenario: Create new auction
    Given I'm logged in as an admin
    When I create a silent auction with the following:
      | title        | description            | min_price | open |
      | sample title | this is my description | 250       | yes  |

    Then a valid silent auction is created with the following:
      | title        | description            | min_price | open |
      | sample title | this is my description | 250       | yes  |


    @javascript
    Scenario: Upload Duplicate Image
    Given I'm logged in as a user
    When I create a silent auction
    And I select upload File with name <image.jpg>
    And I choose to upload one more file with name <image.jpg>
    Then I'm able to upload both images




