Feature: User Authentication

  @javascript
  Scenario: User login
    When I'm logged in as a user
    Then I can see my login status

  @javascript
  Scenario: Region Validation
    Given I'm logged in as a new user
    When I select my region
    Then I can see my region

  @javascript
  Scenario: Admin login
    When I'm logged in as an admin
    Then I can see my login status
    And I can see my account is admin

  @javascript
  Scenario: User/Admin logout
    Given I'm logged in as a user
    When I logout from the system
    Then I will be logged out


















