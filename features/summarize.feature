Feature: Disk Summarization
  As a User
  I want to see an LLM-powered summary of my disk's contents
  So that I can quickly understand what is stored on a drive without browsing it

  Background:
    Given a directory named "my_disk"
    And a file named "my_disk/ricdisk_stats_v11.rds" with:
      """
      [file_v1.2] md5_1 100644 f 2024-01-01T12:00:00Z 1000 [text/plain] ./folder_a/file1.txt
      [file_v1.2] md5_2 100644 f 2024-01-01T12:00:00Z 2000 [text/plain] ./folder_a/file2.txt
      """

  Scenario: Manually summarizing a disk
    When I run `storazzo summarize my_disk`
    Then the exit status should be 0
    And a file named "my_disk/storazzo.yaml" should exist
    And the file "my_disk/storazzo.yaml" should contain "llm_description"

  Scenario: Refusing to overwrite an existing summary
    Given a file named "my_disk/storazzo.yaml" with:
      """
      llm_description: Existing Summary
      """
    When I run `storazzo summarize my_disk`
    Then the output should contain "Warning: A summary file already exists"
    And the file "my_disk/storazzo.yaml" should contain "Existing Summary"

  Scenario: Forcing a summary overwrite
    Given a file named "my_disk/storazzo.yaml" with:
      """
      llm_description: Existing Summary
      """
    When I run `storazzo summarize my_disk --force`
    Then the exit status should be 0
    And the output should contain "Generating summary"
    And the file "my_disk/storazzo.yaml" should not contain "Existing Summary"
