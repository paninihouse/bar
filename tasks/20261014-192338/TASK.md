# Align comments and documentation with actual guarantees

- STATUS: OPEN
- PRIORITY: 180
- TAGS: review,docs

Files: README.md, Sources/bar/bar.docc/how-it-works.md, command.md, and comments in Cell.swift, Block.swift, Runner.swift, HEX.swift, and Config.swift.

Problems to review: how-it-works claims all possible errors are caught at build time, but shell commands and malformed color strings are runtime concerns. Cell identity comments imply identity prevents redraws and describe content-derived identity as stable. Timeout comments currently promise more than process termination guarantees. README says exit 0 hides a block without specifying that stdout must be empty.

Approach: Explain concrete contracts simply: source configuration catches Swift type/syntax errors; hiding requires successful execution with no output; SwiftUI identity distinguishes views and is separate from observed content updates. Once code fixes land, align timeout, stderr forwarding, invalid highlight behavior, and hex fallback descriptions with their implemented behavior. Review references after optional HEX removal. Preserve the friendly DIY tone and comments explaining why a choice exists; avoid adding a general architecture manual.

Completion checks: Cross-check each claim against code and tests, build DocC with the project's documented workflow, and correct stale symbol links. This task can be revisited after related fixes; do not pre-document functionality that has not landed.

Design constraint: Follow README.md: keep source-based configuration, no dependencies or plugin framework, and use the smallest readable change that makes the existing behavior reliable. This is a suggestion for individual review, not a deadline. Findings were recorded on 2026-10-14; re-check the current code before implementing.
