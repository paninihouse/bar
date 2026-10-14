# Refresh the font offset patch against a documented base

- STATUS: OPEN
- PRIORITY: 120
- TAGS: review,bug,patches

Files: patches/patch-font_offset-20260810-11d813c.patch and Sources/bar/bar.docc/patches/patch-font-offset.md.

Observed: git apply --check fails on current CellView context, which now uses let cell rather than the older var cell. This optional appearance feature should remain a patch.

Approach: Regenerate against the intended documented revision in an isolated checkout. Preserve Config.fontOffset semantics: negative moves text up, positive moves it down. Keep the cell background and hit area full height while moving only text. Review whether the added Group serves a purpose and choose the simplest view expression. Update filename date/base commit and all documentation URLs together.

Completion checks: Patch checks and applies cleanly on the documented clean base; patched project builds. Test zero, positive, and negative offsets visually with highlighted cells and gestures. If compatibility with other appearance patches is claimed, test the combination or document the required order. Avoid unrelated core edits in the patch.

Design constraint: Follow README.md: keep source-based configuration, no dependencies or plugin framework, and use the smallest readable change that makes the existing behavior reliable. This is a suggestion for individual review, not a deadline. Findings were recorded on 2026-10-14; re-check the current code before implementing.
