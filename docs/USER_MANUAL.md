# Storazzo User Manual

Welcome to Storazzo! This gem helps you manage your physical and cloud media by creating a searchable index of everything you own.

## Configuration

### Environment Variables
Storazzo uses the following environment variables for cloud integration:
- **`PROJECT_ID`**: The Google Cloud Project ID (e.g., `ric-cccwiki`).
- **`GCS_BUCKET`**: The bucket for storing Storazzo metadata (defaults to `PROJECT_ID-storazzo` if unset).
- **`ACCOUNT`**: The Google account used for authentication (e.g., `palladiusbonton@gmail.com`).
- **`GEMINI_API_KEY`**: Required for LLM-generated disk summaries (stored securely in `.env`).

### The .rds File (Ric Disk Stats)
The `.rds` file is the heart of Storazzo's indexing system. When you "scan" a disk or a GCS bucket, Storazzo generates a `.rds` file (typically named `ricdisk_stats_v11.rds`).

#### What's inside an .rds file?
It is a plain-text, newline-separated file where each line represents a file or directory. Each line contains:
1. **Entity Type:** `[file_v1.2]` for local files or `[gcs_v1.2]` for cloud objects.
2. **MD5 Checksum:** A 32-character hexadecimal string representing the file's content.
3. **File Mode:** Unix-style permissions (e.g., `100644`).
4. **File Type:** `f` for file, `d` for directory, `s` for symlink.
5. **Timestamp:** The creation or modification time of the file.
6. **Size:** The file size in bytes.
7. **MIME Type:** The detected content type (e.g., `image/jpeg`).
8. **Filename:** The full relative path to the file.

Example:
`[file_v1.2] d42b9c57d24cf5db3bd8d332dc35437f 100644 f 2026-04-27T12:00:00+00:00 3552 [text/plain] my_document.txt`

### The Search Engine
Storazzo aggregates these `.rds` files into a local SQLite database (`~/.storazzo_index.db`). This allows you to perform lightning-fast searches across all your disconnected drives and cloud buckets.

## Usage

Storazzo provides a CLI tool named `storazzo`.

### Commands

#### 1. Scan a disk or folder
`storazzo scan <PATH>`
Scans a removable disk or local folder, generates an `.rds` file, and uploads metadata to GCS.
Example: `storazzo scan /media/user/MY_DRIVE`

#### 2. Search the index
`storazzo search <QUERY>`
Search for a keyword across all indexed disks and buckets.
Example: `storazzo search "vacation 2024"`

#### 3. Backup to GCS
`storazzo backup <SRC> <DEST_BUCKET>`
Backs up a local folder to GCS using `gsutil rsync` and indexes the destination.
Example: `storazzo backup ~/Photos gs://my-photo-backup`

#### 4. Show configuration and mounts
`storazzo show`
Displays detected mount points, local folders, and GCS buckets.

## Current Project Status (April 27, 2026)

Today, we rebooted the project with the following improvements:
- **Namespace Refactoring:** Cleaned up the internal Ruby module structure for better maintainability.
- **Stable Test Suite:** All core unit tests are passing with >70% coverage goal.
- **Config Management:** Support for `~/.storazzo.yaml` and a secured local copy in `$GIC/projects/storazzo/`.
- **Search Engine Foundation:** Initial implementation of the SQLite indexer and `.rds` parser.

## Next Steps
We are moving into the **Implementation Phase**, focusing on:
1. **Native GCS Integration:** Replacing `gsutil` calls with the `google-cloud-storage` Ruby gem.
2. **Dynamic Disk Discovery:** Better detection of removable media.
3. **Advanced Search:** Improved keyword matching and "offline" drive status tracking.
