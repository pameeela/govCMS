Feature: Standard Page

  Ensure the standard page content displayed correctly

  @api @javascript
  Scenario: View the about us page
    Given I am logged in as a user named "dean" with the "Content editor" role
    When I go to "/node/add/page"
    Then I should see "Create Standard page"
    And I enter "About Us" for "Title"
    And I put "govCMS is the best!" into WYSIWYG "edit-body-und-0-value"
    And press "Save"
    Then I should see "Standard Page About Us has been created"
    Then I logout
    Given I am logged in as a user named "teresa" with the "Content approver" role
    Given I am on "about-us"
    Then I select "Needs Review" from "state"
    And press "Apply"
    Then I should see "Revision state: Needs Review"
    Then I logout
    Given I am logged in as a user named "helen" with the "Content approver" role
    And I am on "about-us"
    Then I select "published" from "state"
    And press "Apply"
    Then I logout
    Given I am on "about-us"
    Then I should see "About Us"
    And I should see an "nav.breadcrumb:contains(About Us)" element
