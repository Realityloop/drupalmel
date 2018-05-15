Feature: Events

  As an anonymous user
  I should be able to see upcoming events.

  @api @javascript
  Scenario: Events
    Given I am on the homepage
    And I save screenshot

    Then I go to "http://node:3000"
    And I save screenshot
