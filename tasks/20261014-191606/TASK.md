# Run daemon event loops so registered callbacks are delivered

- STATUS: OPEN
- PRIORITY: 70
- TAGS: review,bug,deamons

Files: daemons/batteryd.c, brightnessd.c, devicesd.c, networkd.c, focusd.c, nowplayingd.c; corresponding DocC daemon articles.

Problem: Run-loop sources/observers are registered, but the main thread then waits in pause() instead of running its CFRunLoop. Adding a source does not process its events. Treat each daemon's delivery mechanism explicitly; do not assume the CoreAudio or socket daemons need the same fix.

Approach: Use a small run-loop-based wait, with a shutdown strategy that responds to SIGINT/SIGTERM. For example, bounded CFRunLoopRunInMode iterations can check a volatile sig_atomic_t flag; account for absent sources and avoid a busy loop. Validate registration results and fail clearly if setup cannot work. Preserve the editable bar.touch.<block-name> convention.

Completion checks: Build with the compile commands in each source header. After setting an actual block name, trigger battery/network/device events and the relevant distributed notifications; observe posts using notifyutil or the bar. Confirm clean prompt shutdown and no idle spin. Record which hardware events were tested and which remain unverified.

Reference: https://developer.apple.com/documentation/corefoundation/cfrunloopruninmode(_:_:_:).

Design constraint: Follow README.md: keep source-based configuration, no dependencies or plugin framework, and use the smallest readable change that makes the existing behavior reliable. This is a suggestion for individual review, not a deadline. Findings were recorded on 2026-10-14; re-check the current code before implementing.
