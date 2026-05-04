# Implementation Plan - Native MIME-type Optimization

## Phase 1: Benchmarking and Library Selection
- [ ] Task: Create a dedicated benchmarking script
    - [ ] Write a script in `test/benchmark/mime_detection.rb` that measures the time taken to detect MIME types for a set of 100+ mixed files (images, videos, text).
    - [ ] Compare three methods: system `file` command, `mime-types` gem, and `marcel` gem.
- [ ] Task: Execute benchmarks and analyze results
    - [ ] Run the benchmark script on the current environment.
    - [ ] Select the winning library based on speed and accuracy.
- [ ] Task: Conductor - User Manual Verification 'Phase 1: Benchmarking and Library Selection' (Protocol in workflow.md)

## Phase 2: Integration and TDD
- [ ] Task: Update `Gemfile` and Install Dependencies
    - [ ] Add the selected library (or both if comparative testing is needed in-situ) to the `Gemfile`.
    - [ ] Run `bundle install`.
- [ ] Task: Refactor `Storazzo::Stats::FileService`
    - [ ] Write Tests: Create `test/stats/test_mime_optimization.rb` to verify the new detection logic, including the system fallback.
    - [ ] Implement Feature: Update `FileService.compute_stats` to use the native library with a fallback.
- [ ] Task: Conductor - User Manual Verification 'Phase 2: Integration and TDD' (Protocol in workflow.md)

## Phase 3: Final Verification and Cleanup
- [ ] Task: Run Full Test Suite
    - [ ] Ensure all existing tests pass with the new optimization.
    - [ ] Verify that `storazzo scan` and `storazzo show` work as expected.
- [ ] Task: Code Quality and Coverage
    - [ ] Run `rubocop` and verify code coverage meets the >70% target.
- [ ] Task: Conductor - User Manual Verification 'Phase 3: Final Verification and Cleanup' (Protocol in workflow.md)
