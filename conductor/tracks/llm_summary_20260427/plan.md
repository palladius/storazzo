# Implementation Plan - LLM-Generated Disk Summaries

## Phase 1: Deterministic Parsing and Extraction
- [x] Task: Create `FolderStats` extraction logic
    - [x] Write Tests: Validate that parsing a sample `.rds` file accurately identifies the top 5 folders by total size and top 5 by file count. [1c01ec4]
    - [x] Implement Feature: Build the `Storazzo::Stats::FolderExtractor` service to perform this deterministic extraction efficiently. [1c01ec4]
- [ ] Task: Conductor - User Manual Verification 'Phase 1: Deterministic Parsing and Extraction' (Protocol in workflow.md)

## Phase 2: Google Gemini Integration
- [x] Task: Configure Gemini API Client
    - [x] Write Tests: Mock Gemini API responses to verify prompt construction and summary parsing. [39bce8b]
    - [x] Implement Feature: Add necessary gem dependencies (e.g., `google-genai`) and build the `Storazzo::LLM::GeminiSummarizer` service. [c982f08]
- [ ] Task: Conductor - User Manual Verification 'Phase 2: Google Gemini Integration' (Protocol in workflow.md)

## Phase 3: CLI Commands and Automation
- [ ] Task: Integrate automatic trigger into `.rds` generation
    - [ ] Write Tests: Verify the summary YAML is written to disk alongside the `.rds` file upon successful completion of `storazzo scan`.
    - [ ] Implement Feature: Hook the `FolderExtractor` and `GeminiSummarizer` into the end of the `compute_stats_files` workflow.
- [ ] Task: Implement `storazzo summarize <disk>` command
    - [ ] Write Tests: Verify the CLI correctly generates a summary for an existing `.rds` file and refuses to overwrite an existing summary without the `--force` flag.
    - [ ] Implement Feature: Add the `summarize` command to `bin/storazzo` and build the overwrite protection logic.
- [ ] Task: Ingest Legacy Configurations from GIC (P3)
    - [ ] Search `$GIC` for `ricdisk.yml` or `*.rds` files.
    - [ ] Ingest found metadata into SQLite and upload to the central GCS bucket.
- [ ] Task: Conductor - User Manual Verification 'Phase 3: CLI Commands and Automation' (Protocol in workflow.md)