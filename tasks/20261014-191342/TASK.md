# Serialize block commands and preserve gesture order

- STATUS: OPEN
- PRIORITY: 30
- TAGS: review,bug,core

Files: Sources/bar/Models/Block.swift, Sources/bar/Views/BlockView.swift, and behavioral tests.

Problem: Every timer tick, Darwin notification, click, and scroll starts a detached command. Earlier slow results can overwrite newer output; bursts can launch many processes and race script side effects.

Approach: Give each block one running command. Coalesce ordinary refresh requests into at most one pending refresh, while retaining ordered gesture requests and their BUTTON/SCROLL/CELL environment snapshots. Explicitly review how pending gestures and refreshes interleave. A generation counter alone fixes stale display results but does not serialize side effects. Keep the implementation local to Block and readable; avoid introducing a generic scheduling framework. Consider what a large gesture burst should do without silently losing user actions.

Completion checks: Controlled slow and fast commands cannot produce stale overwrites. A refresh burst has bounded pending refresh work. Click/scroll side effects execute in order, with correct environment values. Separate blocks can still run independently and main-actor UI remains responsive. Reuse Runner timeout behavior rather than duplicating process control.

Design constraint: Follow README.md: keep source-based configuration, no dependencies or plugin framework, and use the smallest readable change that makes the existing behavior reliable. This is a suggestion for individual review, not a deadline. Findings were recorded on 2026-10-14; re-check the current code before implementing.
