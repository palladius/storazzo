# Specification: Implement GCS Backup and MD5 Searchable Catalog for Removable Disks

## Overview
This track focuses on rebooting the `storazzo` gem to support cloud backups to GCS, creating a searchable MD5 catalog of all files across drives, and robustly handling removable media.

## Functional Requirements
- **Removable Disk Support:** Identify, parse, and catalog files from removable disks (e.g., external HDDs, USB sticks).
- **MD5 Hashing:** Compute MD5 checksums for all cataloged files to ensure data integrity and enable deduplication/search.
- **Searchable Database:** Store catalog data in a local SQLite database for fast querying (e.g., searching for "scuba diving").
- **GCS Backup:** Upload cataloged data and/or physical files to Google Cloud Storage buckets for cloud backup.

## Non-Functional Requirements
- **Performance:** Efficient hashing and database indexing.
- **Reliability:** Safe handling of offline disks and failed network connections.
- **User Interface:** Friendly CLI output with progress indicators.