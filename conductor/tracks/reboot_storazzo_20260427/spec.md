# Specification: Reboot Storazzo

## Overview
Reboot the `storazzo` gem to provide a modern, high-performance tool for cataloging and backing up media across local disks (removable) and Google Cloud Storage.

## User Stories
- **As a User**, I want to scan a removable disk and have its file metadata (including MD5s) uploaded to GCS so I have a cloud-based index.
- **As a User**, I want to search my entire collection (local and cloud) for specific files using keywords like "scuba diving" and see which disk or bucket they are on.
- **As a User**, I want to leverage my existing `~/.storazzo.yaml` configuration to automatically discover my backup buckets.

## Functional Requirements
- **Native GCS Client:** Replace `gsutil` dependencies with the `google-cloud-storage` Ruby gem for reliable metadata and file sync.
- **SQLite Indexing:** Implement a robust `SearchEngine` that parses `.rds` files and stores them in a local SQLite database.
- **Removable Disk Detection:** Improve the detection and parsing of removable media mounted on the system.
- **BDD Coverage:** Implement Cucumber or RSpec feature specs to validate the core use cases.

## Non-Functional Requirements
- **Performance:** Optimized hashing and database ingestion to handle thousands of files.
- **Friendly CLI:** Approachable output with progress bars and emoji.
- **Safety:** Confirmations before large-scale operations.