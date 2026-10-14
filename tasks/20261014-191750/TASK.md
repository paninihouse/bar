# Make spaced monitor Space changes rather than display changes

- STATUS: OPEN
- PRIORITY: 100
- TAGS: review,bug,deamons

Files: daemons/spaced.c and Sources/bar/bar.docc/daemons/daemon-spaced.md.

Problem: The daemon polls CGSCopyActiveMenuBarDisplayIdentifier and compares display identifiers. This does not establish that changing Spaces on the same display will be detected, despite the advertised purpose. The hardcoded private framework path/symbol also needs verification on supported macOS.

Approach: Reproduce same-display Space switching before choosing a fix. Prefer a narrow public workspace-change notification if practical, even if the standalone daemon must be compiled as Objective-C with AppKit. Otherwise verify an actual Space identifier source and document private-API limits. Keep this functionality outside the Swift core. Remove unused pollCount if no longer needed and update compile instructions when the implementation language/framework changes.

Completion checks: Switching Spaces on one display causes a refresh. Check multiple displays and display focus changes where available; distinguish these from Space changes. Startup or API loading failures report clearly. Verify shutdown and idle resource use. Record tested macOS version and avoid claiming untested hardware behavior.

Design constraint: Follow README.md: keep source-based configuration, no dependencies or plugin framework, and use the smallest readable change that makes the existing behavior reliable. This is a suggestion for individual review, not a deadline. Findings were recorded on 2026-10-14; re-check the current code before implementing.
