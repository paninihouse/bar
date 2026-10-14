# Align comments and documentation with actual guarantees

- STATUS: CLOSED
- PRIORITY: 180
- TAGS: review,docs

Files: README.md, Sources/bar/bar.docc/how-it-works.md, command.md, and comments in Cell.swift, Block.swift, Runner.swift, HEX.swift, and Config.swift.

Problems to review: how-it-works claims all possible errors are caught at build time, but shell commands and malformed color strings are runtime concerns. Cell identity comments imply identity prevents redraws and describe content-derived identity as stable. Timeout comments currently promise more than process termination guarantees. README says exit 0 hides a block without specifying that stdout must be empty.

Approach: Explain concrete contracts simply: source configuration catches Swift type/syntax errors; hiding requires successful execution with no output; SwiftUI identity distinguishes views and is separate from observed content updates. Once code fixes land, align timeout, stderr forwarding, invalid highlight behavior, and hex fallback descriptions with their implemented behavior. Review references after optional HEX removal. Preserve the friendly DIY tone and comments explaining why a choice exists; avoid adding a general architecture manual.

Completion checks: Cross-check each claim against code and tests, build DocC with the project's documented workflow, and correct stale symbol links. This task can be revisited after related fixes; do not pre-document functionality that has not landed.

Design constraint: Follow README.md: keep source-based configuration, no dependencies or plugin framework, and use the smallest readable change that makes the existing behavior reliable. This is a suggestion for individual review, not a deadline. Findings were recorded on 2026-10-14; re-check the current code before implementing.

## Completion

Updated README and DocC to distinguish compile-time Swift checks from runtime
shell and color behavior, require successful empty stdout for hiding, describe
line parsing and actual stderr/error handling, and explain the limits of the
30-second termination request. Cell and Block comments distinguish identity from
content updates; Cell documents its content-derived ID and BlockView's current
positional rendering. Config and HEX comments describe runtime color parsing,
unsupported-length fallback, partial scanning, and disabled repeating intervals.
Highlighting documentation qualifies prefix stripping and invalid levels against
the current parser. HEX remains implemented and its symbol links remain valid;
Color.hex(_:) is formatted as code because DocC does not emit a linkable page for
that extension member in this catalog.

Validation: reviewed claims against the current implementations and existing
hover/lifetime tests; `make -C Sources/bar/bar.docc build` completed without
warnings or unresolved symbol links; `swift test` passed all four existing tests;
`git diff --check` passed. Runtime behavior is unchanged.
