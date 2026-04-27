# Implementation Plan - Reboot Storazzo

## Phase 1: Research and Core Infrastructure
- [ ] Task: Audit existing `storazzo` media parsing logic
    - [ ] Review `lib/storazzo/media/` classes
    - [ ] Identify gaps in removable disk detection
- [ ] Task: Set up SQLite database schema for file cataloging
    - [ ] Define tables for disks, directories, and files (with MD5)
    - [ ] Implement database initialization logic
- [ ] Task: Conductor - User Manual Verification 'Phase 1: Research and Core Infrastructure' (Protocol in workflow.md)

## Phase 2: Removable Disk and MD5 Cataloging
- [ ] Task: Implement TDD for Removable Disk parsing
    - [ ] Write Tests: Verify detection of various mount points
    - [ ] Implement Feature: Refactor `LocalFolder` or `MountPoint` to handle removable state
- [ ] Task: Implement TDD for MD5 hashing service
    - [ ] Write Tests: Verify MD5 computation for various file types/sizes
    - [ ] Implement Feature: Efficient hashing service with progress bars
- [ ] Task: Implement Cataloging logic
    - [ ] Write Tests: Verify storage of parsed data into SQLite
    - [ ] Implement Feature: Command to "scan" a disk and populate the DB
- [ ] Task: Conductor - User Manual Verification 'Phase 2: Removable Disk and MD5 Cataloging' (Protocol in workflow.md)

## Phase 3: GCS Integration and Search
- [ ] Task: Implement TDD for GCS Backup
    - [ ] Write Tests: Mock GCS uploads and verify success/retry logic
    - [ ] Implement Feature: Upload local catalog/database to a specified GCS bucket
- [ ] Task: Implement Search Functionality
    - [ ] Write Tests: Verify keyword search across the SQLite database
    - [ ] Implement Feature: `storazzo search <query>` command
- [ ] Task: Conductor - User Manual Verification 'Phase 3: GCS Integration and Search' (Protocol in workflow.md)