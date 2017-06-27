Feature: Embed YouTube videos in content

  Users can embed a YouTube video

  @api @javascript
  Scenario: Embed YouTube video
    Given I am logged in as a user named "sam" with the "Content editor" role
    And I go to "node/add/page"
    And I enter "Test" for "Title"
    And I put "[video:https://www.youtube.com/watch?v=_zzjd1xadyA]" into WYSIWYG "edit-body-und-0-value"
    And I press "Save"
    Then I should see an "iframe.video-filter" element
