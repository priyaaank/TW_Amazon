Feature: user authentication

Scenario: user login
Given I am a registered cas user
When I login to the system
Then I will be logged in

Scenario: user logoff
Given I am already login to the system
When I logout from the system
Then I will be logged out


















