# Resolve BlockView capture warning and clarify monitor lifetime

- STATUS: CLOSED
- PRIORITY: 190
- TAGS: review,quality,ui

File: Sources/bar/Views/BlockView.swift.

Observed: swift test builds with an ImplicitStrongCapture warning at the inner [weak block] capture because onAppear implicitly captures block strongly. The monitor also captures self to access hover state, so the weak block capture alone does not establish weak ownership of all associated state.

Approach: Inspect the actual closure ownership chain and choose explicit, intentional captures. Follow the compiler's outer capture-list guidance where appropriate, rather than suppressing the diagnostic. Keep monitor creation/removal paired across appearance/disappearance; guard against duplicate registrations if lifecycle behavior permits repeated onAppear calls. Coordinate hover storage changes with the positional-identity task. A small fix is preferable to a new event framework.

Completion checks: A clean swift build/test has no warning from this capture. Click/scroll receives correct current hover data. Hide/show and any applied screen-rebuild patch do not accumulate monitors, duplicate command dispatch, or retain discarded views/windows. Manually verify lifecycle behavior before claiming leak prevention.

Design constraint: Follow README.md: keep source-based configuration, no dependencies or plugin framework, and use the smallest readable change that makes the existing behavior reliable. This is a suggestion for individual review, not a deadline. Findings were recorded on 2026-10-14; re-check the current code before implementing.

## Implementation and validation

Implemented explicit weak captures through a per-view BlockInteraction owner.
Registration is idempotent; disappearance removes the monitor and clears hover,
and an isolated deinitializer removes any remaining monitor when its owner is
released. Rendering and hover use line positions, resolving CELL against current
block output and rejecting positions removed by a refresh. This supplies the
BlockView portion of task 20261014-191457 without changing Cell's public model.

A clean swift test build passes the monitor registration/restart, weak owner and
block lifetime, and refreshed/removed hover regression tests. No capture warning
remains. The optional screen-hotplug patch is not applied (it targets the old
Models/AppDelegate.swift path).

Status remains OPEN pending manual UI verification: repeat hide/show, click and
scroll after output refresh/shrink, check multiple windows and hover transitions,
and discard/rebuild hosting windows while checking monitor dispatch and window
release. Automated owner lifetime tests do not establish that SwiftUI releases
hosting state in every UI lifecycle path; leak prevention is not claimed.
