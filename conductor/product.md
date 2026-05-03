# Initial Concept
A reboot of the ancient ruby gem `storazzo` focusing on GCS cloud backups, listing backups with MD5s for search (e.g., finding files like "scuba diving in the philippines"), and handling removable disks.

# Target User
Power users managing personal media and files across multiple drives, removable media, and cloud storage solutions.

# Core Value Proposition
A robust, searchable catalog indexing all files, complete with MD5 checksums, mapping across both local drives (including offline removable media) and Google Cloud Storage.

# Key Features
- **GCS Integration:** Seamless synchronization and backups to Google Cloud Storage.
- **MD5 Cataloging:** Deep indexing of files with MD5 hashing, aggregated into a local database (SQLite) for fast, robust search capabilities.
- **Removable Disks:** First-class support for parsing, tracking, and cataloging offline or removable media, allowing users to locate files even when the disk is detached.
- **LLM-Generated Summaries:** Automatic and manual generation of human-readable disk descriptions and content categorization using Google Gemini, providing an immediate overview of a disk's contents.