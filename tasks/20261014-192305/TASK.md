# Review and remove unused HEX conversion surface

- STATUS: OPEN
- PRIORITY: 170
- TAGS: review,cleanup,core

File: Sources/bar/Models/HEX.swift; references across Sources, Tests, documentation, and patches.

Observation: The core uses Color.hex(String), while the HEX wrapper, Color.init(hex:), and Color.Resolved.hex reverse conversion appear unnecessary for current runtime behavior. They add concepts a reader must understand in a deliberately small project.

Approach: Search all references first, including documentation and published patch expectations. Decide whether these helpers are intentionally useful to users customizing Swift source. If they have a concrete use, keep them and document it briefly; otherwise remove the unused wrapper/reverse-conversion surface and update Config comments/DocC references to the remaining helper. Treat removal as an optional design decision, not a correctness requirement. Preserve direct .hex("#...") convenience.

Completion checks: swift build and swift test pass; no dangling HEX symbol links or references remain. Supported hex syntax and Config appearance are unchanged. Explain the kept/removed API choice in the change description so it can be reviewed separately from strict input validation.

Design constraint: Follow README.md: keep source-based configuration, no dependencies or plugin framework, and use the smallest readable change that makes the existing behavior reliable. This is a suggestion for individual review, not a deadline. Findings were recorded on 2026-10-14; re-check the current code before implementing.
