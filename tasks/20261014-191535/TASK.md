# Parse highlight prefixes without regex backtracking surprises

- STATUS: OPEN
- PRIORITY: 60
- TAGS: review,bug,core

Files: Sources/bar/Models/Cell.swift, Sources/bar/bar.docc/highlighting.md, and parser tests.

Reproduced behavior: "&!12" parses as highlight 1 plus text "2", because the optional digit capture backtracks to satisfy the required nonempty body. "&!1" remains literal text. Existing valid output such as "&!1 hello" must keep its leading space after the prefix.

Approach: Define the contract for a prefix with no body, zero/out-of-range levels, malformed prefixes, integer overflow, and digit characters accepted. Recognize only a leading &!, consume its entire digit sequence, then parse the remaining text without trimming. Prefer a short explicit parser if it makes ownership and edge cases easier to understand. Decide whether invalid levels strip the prefix or preserve literal text, and document the choice.

Completion checks: Cover ordinary text, valid levels, &!1, &!12, &!0 text, out-of-range and huge levels, malformed prefixes, embedded &!, empty text, and whitespace-only bodies. No partial level interpretation is possible. Preserve the existing one-based Config.highlights convention.

Design constraint: Follow README.md: keep source-based configuration, no dependencies or plugin framework, and use the smallest readable change that makes the existing behavior reliable. This is a suggestion for individual review, not a deadline. Findings were recorded on 2026-10-14; re-check the current code before implementing.
