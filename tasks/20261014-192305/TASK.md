# Review and remove unused HEX conversion surface

- STATUS: CLOSED
- PRIORITY: 170
- TAGS: review,cleanup,core

File: Sources/bar/Models/HEX.swift; references across Sources, Tests, documentation, and patches.

Observation: The core uses Color.hex(String), while the HEX wrapper, Color.init(hex:), and Color.Resolved.hex reverse conversion appear unnecessary for current runtime behavior. They add concepts a reader must understand in a deliberately small project.

Approach: Search all references first, including documentation and published patch expectations. Decide whether these helpers are intentionally useful to users customizing Swift source. If they have a concrete use, keep them and document it briefly; otherwise remove the unused wrapper/reverse-conversion surface and update Config comments/DocC references to the remaining helper. Treat removal as an optional design decision, not a correctness requirement. Preserve direct .hex("#...") convenience.

Completion checks: swift build and swift test pass; no dangling HEX symbol links or references remain. Supported hex syntax and Config appearance are unchanged. Explain the kept/removed API choice in the change description so it can be reviewed separately from strict input validation.

Design constraint: Follow README.md: keep source-based configuration, no dependencies or plugin framework, and use the smallest readable change that makes the existing behavior reliable. This is a suggestion for individual review, not a deadline. Findings were recorded on 2026-10-14; re-check the current code before implementing.

## Completion

Reference review found no callers of the HEX wrapper, Color.init(hex:), or
Color.Resolved.hex in Sources, Tests, examples, or published patches. Removed
these unused conversions to keep source customization focused on the existing
Color.hex(String) helper. Moved that helper to Models/Color+Hex.swift and updated
Config and DocC references. The published background-blur patch uses only the
retained .hex(String) helper and needs no change.

This is API simplification, separate from strict input validation: the parser
body is byte-for-byte unchanged, as are configured foreground, background, and
highlight values. Supported syntax and existing malformed-input behavior remain
unchanged. Users with private customizations that call the removed helpers can
use Color.hex(code) for forward conversion or keep their own conversion helpers.

Validation: swift build succeeded; swift test passed all four existing tests;
make -C Sources/bar/bar.docc build completed without warnings or unresolved
links; reference search found no remaining removed-API references in Sources,
Tests, patches, or README; git diff --check passed.
