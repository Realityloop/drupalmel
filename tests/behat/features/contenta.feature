Feature: ContentaCMS

  As an anonymous user
  I should be able to access the website

  Scenario: Simple bootstrap
    Given I am on "http://cms.drupalmel.localhost"
    And I see the text "The requested page could not be found."
    And I see the text "Log in"
