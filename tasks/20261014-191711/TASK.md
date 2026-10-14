# Remove the exact CoreAudio listeners that volumed registers

- STATUS: OPEN
- PRIORITY: 90
- TAGS: review,bug,deamons

File: daemons/volumed.c and Sources/bar/bar.docc/daemons/daemon-volumed.md.

Problem: Registration selects the preferred output channel dynamically, but removal hardcodes channel 1. Mute listeners on old devices are never removed. Shutdown removes neither the mute listener nor the system default-device listener. Switching devices also does not directly refresh the block's display.

Approach: Retain the exact registered property addresses and device ID, with registration success state. Remove both volume and mute listeners before changing devices and on shutdown; remove the system listener too. Check CoreAudio return values and handle devices without the expected volume property. Review callback concurrency when mutating shared registration state. Post a refresh when output-device changes so display catches up even without a volume event.

Completion checks: Switch repeatedly between built-in output and available headphones/external devices. Confirm notifications follow only the active device and selected channel, mute updates work, no listener accumulates, unsupported properties produce useful diagnostics, and shutdown cleans up. Document actual hardware tested.

Design constraint: Follow README.md: keep source-based configuration, no dependencies or plugin framework, and use the smallest readable change that makes the existing behavior reliable. This is a suggestion for individual review, not a deadline. Findings were recorded on 2026-10-14; re-check the current code before implementing.
