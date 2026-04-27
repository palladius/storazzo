# Specification: LLM-Generated Disk Summaries

## Overview
Integrate a smart workflow combining deterministic analysis and LLM generation (using Google Gemini) to produce a concise, descriptive YAML summary for each `.rds` stats file. This summary will provide an immediate understanding of a disk's overall content and structure.

## Functional Requirements
- **Deterministic Extraction:** Parse the `.rds` file to accurately calculate the top 5 folders by total size and the top 5 folders by file count.
- **LLM Summarization (Google Gemini):** Pass the extracted statistics to Google Gemini to generate a 1-2 sentence human-readable description of the disk's contents and categorize the primary content types (e.g., 'Mostly Videos', 'Source Code').
- **Automatic Trigger:** Automatically generate the YAML summary file immediately after a new `.rds` stats file is created.
- **Manual CLI Command:** Provide a CLI command (e.g., `storazzo summarize <disk>`) to manually generate the YAML summary for existing `.rds` files that were created before this feature.
- **Overwrite Protection:** The manual CLI command must check if a summary YAML already exists. If it does, it must refuse to overwrite it and prompt the user to use a `--force` flag to rewrite it.

## Non-Functional Requirements
- **Performance:** The deterministic parsing of the `.rds` file must be highly efficient, especially for disks with millions of files.
- **Resilience:** Graceful handling of LLM API errors (e.g., timeouts, rate limits) ensuring the main `storazzo` application does not crash.

## Acceptance Criteria
- Running `storazzo scan` (or equivalent) creates both the `.rds` file and a corresponding YAML summary file.
- The YAML file contains: Top 5 folders by size, Top 5 folders by count, an overall description, and content categorization.
- Running `storazzo summarize <disk>` successfully creates the YAML file for a disk that only has an `.rds` file.
- Running `storazzo summarize <disk>` on a disk that already has a YAML summary exits safely with a warning, unless `--force` is appended.