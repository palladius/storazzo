Feature: Search Catalog
  As a User
  I want to search for files across my indexed disks
  So that I can locate my media instantly

  Scenario: Searching for a specific file by keyword
    Given a local SQLite index with the following entries:
      | disk       | path                      | md5      |
      | TurboSeby | ./diving/raja_ampat.mp4   | abc123def |
      | SDCard    | ./images/gopro_hero.jpg   | xyz789ghi |
    When I run `storazzo search raja`
    Then the output should contain "TurboSeby"
    And the output should contain "./diving/raja_ampat.mp4"
