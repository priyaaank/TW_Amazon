Feature: picture

@javascript
Scenario: upload images
Given I'm logged in as an admin
When I create a valid silent auction
And I want to upload <image> as following:
| image |
| image1.jpg |
| image2.jpg |
| image3.jpg |
| image4.jpg |
Then the <image> is attached

@javascript
Scenario: delete images
Given I'm logged in as an admin
When I delete "image1.jpg"
Then I cannot see "image1.jpg"