# Make command timeout and process cleanup bounded

- STATUS: OPEN
- PRIORITY: 20
- TAGS: review,bug,core

Files: Sources/bar/Models/Runner.swift and its tests.

Problem: The 30-second timer calls Process.terminate(), which sends SIGTERM to the shell. A process can ignore it; descendants can retain stdout/stderr handles and prevent EOF even after the shell exits. The documented timeout is therefore not a reliable bound.

Approach: First reproduce a SIGTERM-ignoring command and a shell with a descendant retaining pipe handles. Choose the smallest macOS-compatible process ownership mechanism that can terminate only this command's process tree, escalate after a short grace period, and finish pipe reads. Do not signal the bar's own process group or unrelated processes. Handle timer cancellation, PID lifetime, reader cleanup, and reaping on every exit path. Document any unavoidable limitation honestly.

Completion checks: Normal commands complete without later signals. Both reproductions return ERROR within timeout plus documented grace, release readers, and leave no owned child running. Allow a short timeout in tests without adding a user-facing configuration system. Review together with concurrent pipe draining.

Design constraint: Follow README.md: keep source-based configuration, no dependencies or plugin framework, and use the smallest readable change that makes the existing behavior reliable. This is a suggestion for individual review, not a deadline. Findings were recorded on 2026-10-14; re-check the current code before implementing.
