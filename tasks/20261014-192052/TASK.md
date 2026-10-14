# Replace the placeholder test with focused protocol tests

- STATUS: OPEN
- PRIORITY: 140
- TAGS: review,quality,tests

Files: Tests/barTests/phbarTests.swift, Sources/bar/Models/Runner.swift, Sources/bar/Models/Cell.swift.

Observed: swift test succeeds, but the sole example test contains no assertions. A small regression suite would protect the shell protocol users rely on without adding production abstractions just for coverage.

Approach: Replace example() with named Swift Testing cases for Runner.parse: empty string -> [], one trailing newline removed, internal and additional trailing blank lines preserved, line order unchanged, and spaces not trimmed. Add highlight cases once the parsing contract is agreed. Cover repeated identical cells in the identity task. Process deadlock/timeout and execution-order regressions belong beside their respective fixes, rather than duplicating them here. Respect actor isolation for Config/UI-derived values.

Completion checks: swift test executes meaningful assertions and all pass. Tests describe public behavioral contracts rather than copying implementation logic or relying on the user's scripts/hardware. Keep process fixtures bounded and deterministic. No screenshot suite, testing dependency, or general mock framework is required.

Design constraint: Follow README.md: keep source-based configuration, no dependencies or plugin framework, and use the smallest readable change that makes the existing behavior reliable. This is a suggestion for individual review, not a deadline. Findings were recorded on 2026-10-14; re-check the current code before implementing.
