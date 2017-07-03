Feature: Blog Article

  Ensure the Media Release content type was created during installation.

  @api @javascript
  Scenario: Check that the Body WYSIWYG editor is available.
    Given I am logged in as a user with the "Content editor" role
    When I visit "/node/add/blog-article"
    Then CKEditor "edit-body-und-0-value" should exist

  @api @javascript
  Scenario: Create Media Release content and check how it's displayed.
    Given I am logged in as a user with the "administrator" role
    Given "tags" terms:
      | name   |
      | acquia |
    When I go to "/node/add/blog-article"
    Then I should see "Create Blog Article"
    And I fill in the following:
      | Title   | New blog               |
      | Summary | How we migrated to govCMS! |
    Then I set the chosen element "Tags" to "acquia"
    And I put "Digital transformation is real. GovCMS is the best!" into WYSIWYG "edit-body-und-0-value"
    When I open the "Feature Image" media browser
    Then I attach the file "autotest.jpg" to "files[upload]"
    And I press "Next"
    Then I fill in "Auto Test" for "Name"
    And I fill in "govCMS test image" for "Alt Text"
    And I submit the media browser
    Then the "#edit-field-thumbnail" element should contain "Edit"
    And the "#edit-field-thumbnail" element should contain "Remove"
    Given I click "Publishing options"
    Then I select "Published" from "Moderation state"
    And I press "Save"
    Then I should see the success message containing "Blog Article New blog has been created."
    And I logout
    Given I am an anonymous user
    When I visit "/news-media/blog"
    Then I should see the heading "Blog"
    And the response should contain "<a href=\"/news-media/blog/new-blog\">New blog</a>"
    And I should see the text "Submitted by"
    And I should see the "img" element with the "width" attribute set to "220" in the "content" region
    And I should see the "img" element with the "height" attribute set to "220" in the "content" region
    And I should see the text "How we migrated to govCMS!"
    And I should see the link "Read more"
    Given I click "New blog"
    Then the "h1" element should contain "New blog"
    And I should see the text "Submitted by"
    And I should see the "img" element with the "width" attribute set to "620" in the "content" region
    And I should see the "img" element with the "height" attribute set to "349" in the "content" region
    And the response should contain "/files/styles/article_page_620x349/public/images/blog/autotest.jpg"
    And I should see "Digital transformation is real. GovCMS is the best!"
    And the ".field-name-field-tags" element should contain "<a href=\"/tags/acquia\""
    And I should see the link "acquia"


  @api
  Scenario: Check that moderation works.
    Given "blog_article" content:
      | title       | author     | status | state |
      | Agency blog | Jim Editor | 0      | draft |
    And I am logged in as a user with the "Content approver" role
    When I am on "/news-media/blog/agency-blog"
    Then I select "Needs Review" from "Moderation state"
    And press "Apply"
    And I logout
    Given I am logged in as a user with the "Content approver" role
    When I am on "/news-media/blog/agency-blog"
    Then I select "Published" from "Moderation state"
    And press "Apply"
    And I logout
    Given I am an anonymous user
    When I visit "/news-media/blog/agency-blog"
    Then I should see the heading "Agency blog"

  @api
  Scenario: Check that custom menu links are disabled by default.
    Given "blog_article" content:
      | title       | author     | status | state         |
      | Agency blog | Jim Editor | 0      | needs_review     |
    And I am logged in as a user with the "administrator" role
    When I am on "/news-media/blog/agency-blog"
    Then I click "Edit draft"
    And I should not see "Menu settings"