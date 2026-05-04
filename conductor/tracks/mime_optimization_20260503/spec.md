# Specification - Native MIME-type Optimization

## Overview
The goal of this track is to optimize the performance of file indexing in `Storazzo` by replacing the current system-dependent `file` command calls with a native Ruby MIME-type detection library. We will evaluate both `mime-types` and `marcel` libraries to determine which offers the best performance and accuracy for our target use case (media files).

## Functional Requirements
- **Library Evaluation:** Implement and benchmark both `mime-types` and `marcel` for detecting MIME types of various files, specifically images and videos.
- **Service Integration:** Integrate the chosen (or both for comparative testing) library into `Storazzo::Stats::FileService`.
- **System Fallback:** Implement a fallback mechanism to the system `file` command if the native library fails to identify a file's MIME type.
- **Benchmarking Tool:** Create a benchmark script to quantify the performance improvement over the existing shell-based method.

## Non-Functional Requirements
- **Performance:** Significantly reduce the time spent on MIME-type detection during disk scanning.
- **Portability:** Improve the tool's portability by reducing reliance on external OS commands.
- **Reliability:** Maintain the existing accuracy of MIME-type detection.

## Acceptance Criteria
- [ ] A benchmarking script exists that compares `file` command, `mime-types` gem, and `marcel` gem.
- [ ] `Storazzo::Stats::FileService` uses a native Ruby library for MIME detection.
- [ ] All tests pass, including new tests for the optimization.
- [ ] Code coverage for new/modified logic is >70%.

## Out of Scope
- Optimizing MD5 hashing (already optimized).
- Modifying GCS upload logic.
