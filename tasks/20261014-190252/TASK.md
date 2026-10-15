# Drain command stdout and stderr concurrently

- STATUS: CLOSED
- PRIORITY: 10
- TAGS: review, bug, core

Files: Sources/bar/Models/Runner.swift, Tests/barTests/phbarTests.swift.

Problem: Runner reads stdout to EOF before draining stderr. A child that fills the stderr pipe blocks on writing; Runner waits for stdout EOF, so a valid command can stall until timeout.

Approach: Drain both pipes concurrently using a small, clearly owned implementation. Avoid moving blocking reads onto the main actor or filling Swift's cooperative executor with unbounded blocking work. Preserve /bin/sh -c, inherited environment, output whitespace, newline parsing, and ERROR cells on nonzero exit. Decide whether stderr should be forwarded on successful exits too; command.md currently promises forwarding without that qualification.

Completion checks: A command writes substantially more than pipe capacity to stderr and then emits stdout; it finishes promptly and stdout is correct. Check simultaneous large stdout/stderr, normal empty output, and nonzero exit diagnostics. Add focused regression tests with an outer deadline so a failure cannot hang the test suite. Coordinate timeout ownership with the separate timeout task.

Design constraint: Follow README.md: keep source-based configuration, no dependencies or plugin framework, and use the smallest readable change that makes the existing behavior reliable. This is a suggestion for individual review, not a deadline. Findings were recorded on 2026-10-14; re-check the current code before implementing.

Implemented 2026-10-15: the blocking caller drains stdout while one GCD worker
reads and forwards stderr, including on success. A DispatchGroup joins the
worker before returning. Existing timeout behavior is unchanged.

Validation: `swift test` passes all 13 tests. Regression cases cover 1 MiB
stderr before stdout, simultaneous 1 MiB streams, empty output, nonzero exit
diagnostics, and shell environment/whitespace preservation. Each uses a
five-second outer wait so a stalled Runner fails the test promptly.
