# Resolve BlockView capture warning and clarify monitor lifetime

- STATUS: OPEN
- PRIORITY: 190
- TAGS: review,quality,ui

File: Sources/bar/Views/BlockView.swift.

Observed: swift test builds with an ImplicitStrongCapture warning at the inner [weak block] capture because onAppear implicitly captures block strongly. The monitor also captures self to access hover state, so the weak block capture alone does not establish weak ownership of all associated state.

Approach: Inspect the actual closure ownership chain and choose explicit, intentional captures. Follow the compiler's outer capture-list guidance where appropriate, rather than suppressing the diagnostic. Keep monitor creation/removal paired across appearance/disappearance; guard against duplicate registrations if lifecycle behavior permits repeated onAppear calls. Coordinate hover storage changes with the positional-identity task. A small fix is preferable to a new event framework.

Completion checks: A clean swift build/test has no warning from this capture. Click/scroll receives correct current hover data. Hide/show and any applied screen-rebuild patch do not accumulate monitors, duplicate command dispatch, or retain discarded views/windows. Manually verify lifecycle behavior before claiming leak prevention.

Design constraint: Follow README.md: keep source-based configuration, no dependencies or plugin framework, and use the smallest readable change that makes the existing behavior reliable. This is a suggestion for individual review, not a deadline. Findings were recorded on 2026-10-14; re-check the current code before implementing.
