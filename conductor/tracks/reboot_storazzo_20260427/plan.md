# Implementation Plan - Reboot Storazzo

## Phase 1: Foundation and BDD Setup
- [x] Task: Initialize BDD environment
    - [x] Add `rspec` and `cucumber` to `Gemfile`
    - [x] Create initial feature files for "Scan Removable Disk" and "Search Catalog"
- [x] Task: Refine Configuration and GCS Client
    - [x] Implement `Storazzo::GCS::Client` using the `google-cloud-storage` gem
    - [x] Add logic to auto-detect project ID and validate bucket access from `~/.storazzo.yaml`
- [x] Task: Conductor - User Manual Verification 'Phase 1: Foundation and BDD Setup' (Protocol in workflow.md) [287b04f]

## Phase 2: Enhanced Cataloging and Search
- [x] Task: Implement Search Engine Ingestion
    - [x] Enhance `SearchEngine#ingest_stats_file` to handle both local and GCS paths (optimized with transactions) [945275a]
    - [x] Implement `SearchEngine#sync_from_gcs` to loop through all buckets in config [217c645]
- [x] Task: Optimize MD5 Hashing
    - [x] Refactor `stats-with-md5` logic into a reusable Ruby service
    - [x] Add progress indicators for hashing and database ingestion
- [ ] Task: Conductor - User Manual Verification 'Phase 2: Enhanced Cataloging and Search' (Protocol in workflow.md)

## Phase 3: Removable Disk and GCS Sync
- [ ] Task: Advanced Removable Disk Handling
    - [ ] Implement dynamic mount point discovery (beyond hardcoded paths)
    - [ ] Add "offline" status tracking for disks in the SQLite index
- [ ] Task: Robust GCS Backup
    - [ ] Implement `storazzo backup` command that syncs files and updates the cloud metadata index
    - [ ] Add safety confirmations for large transfers
- [ ] Task: Conductor - User Manual Verification 'Phase 3: Removable Disk and GCS Sync' (Protocol in workflow.md)