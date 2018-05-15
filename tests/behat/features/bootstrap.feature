Feature: Bootstrap

  As an anonymous user
  I should be able to access the website(s).

  Scenario: Backend (ContentaCMS)
    Given I am on "http://cms.drupalmel.localhost"
    And I see the text "The requested page could not be found."
    And I see the text "Log in"

  Scenario: Frontend (Nuxt.js)
    Given I am on "http://drupalmel.localhost"
    And I see the text "DrupalMelbourne"
    And I see the text "Upcoming events"
