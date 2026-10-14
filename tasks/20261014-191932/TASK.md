# Repair the screen hotplug patch and preserve visibility

- STATUS: OPEN
- PRIORITY: 130
- TAGS: review,bug,patches

Files: patches/patch-screen_hotplug-20260810-f6805c9.patch, Sources/bar/Views/AppDelegate.swift, Sources/bar/bar.docc/patches/patch-screen-hotplug.md.

Observed: The patch targets Sources/bar/Models/AppDelegate.swift, which no longer exists. Its rebuilding code calls orderFrontRegardless for every window, so review whether a previously hidden bar would be unexpectedly shown after a screen change.

Approach: Regenerate the optional feature against a documented clean base using the current Views path. Rebuild windows for current display geometry, retain the shared blocks without restarting their timers, and explicitly preserve hide/show state. Verify Swift 6 actor isolation of the notification callback and remove its observer on termination. Ensure discarded windows and event monitors are released. Update filename date/base revision and documentation links.

Completion checks: git apply --check and patched swift build pass. Connect/disconnect a display and change display arrangement/resolution; windows match current frames with no stale bar. Repeat while hidden: it stays hidden until bar.show. Confirm block execution does not multiply and gestures still work after rebuilding.

Design constraint: Follow README.md: keep source-based configuration, no dependencies or plugin framework, and use the smallest readable change that makes the existing behavior reliable. This is a suggestion for individual review, not a deadline. Findings were recorded on 2026-10-14; re-check the current code before implementing.
