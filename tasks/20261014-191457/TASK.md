# Use positional cell identity and current hover content

- STATUS: OPEN
- PRIORITY: 50
- TAGS: review,bug,ui

Files: Sources/bar/Models/Cell.swift, Sources/bar/Models/Block.swift, Sources/bar/Views/BlockView.swift.

Problem: Cell.id combines text and highlight. Identical lines, including repeated blank cells, have duplicate ForEach IDs. Content changes also replace view identity. hoveredCell stores a value snapshot that can become stale after a refresh.

Approach: Use line position as identity because shell output is an ordered list with no semantic IDs. This can be supplied during parsing or through indexed rendering; choose the clearest small implementation. Track the hovered position and resolve its current cell when handling events. Reject a hover index that no longer exists. Update identity comments and check hover exit behavior when views disappear or output changes.

Completion checks: Repeated identical text and blank lines render as distinct cells without duplicate-ID warnings. Text/highlight updates retain positional identity. Clicking after a refresh sends the current text in CELL; shrinking output or removing a hovered cell cannot trigger an unrelated or stale action. Manually check multiple bar windows and hover transitions.

Design constraint: Follow README.md: keep source-based configuration, no dependencies or plugin framework, and use the smallest readable change that makes the existing behavior reliable. This is a suggestion for individual review, not a deadline. Findings were recorded on 2026-10-14; re-check the current code before implementing.
