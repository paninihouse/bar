# Fix IOKit matching dictionary and iterator ownership

- STATUS: OPEN
- PRIORITY: 80
- TAGS: review,bug,deamons

Files: daemons/devicesd.c and daemons/brightnessd.c.

Problem: IOServiceAddMatchingNotification consumes a reference to the matching dictionary, but both files reuse that dictionary in a second registration without retaining it. They also overwrite the iterator variable, and the termination iterator is not initially drained to arm notification delivery. Return values and notification-port creation are unchecked.

Approach: Give each registration a fresh matching dictionary or deliberately retain one reference per call. Store separate first-match and termination iterators, drain each initial result to arm it, and release owned iterators at shutdown. Check failure paths before using returned objects. In brightnessd, IOServiceMatching returning a dictionary does not prove a service exists, so review the claimed fallback behavior separately from ownership.

Completion checks: Compile with warnings enabled. Confirm initial enumeration and subsequent connect/disconnect callbacks after the event-loop task is fixed. Exercise no-matching-device and failed-registration paths without invalid handles or use-after-free. Keep device discovery intentionally narrow and describe supported hardware accurately.

Reference: https://developer.apple.com/documentation/iokit/1514362-ioserviceaddmatchingnotification.

Design constraint: Follow README.md: keep source-based configuration, no dependencies or plugin framework, and use the smallest readable change that makes the existing behavior reliable. This is a suggestion for individual review, not a deadline. Findings were recorded on 2026-10-14; re-check the current code before implementing.
