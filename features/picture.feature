Feature: picture

Scenario: upload images

Given I am admin
When I create a valid silent auction
Then I upload image files
Then I can see images in the silent auction