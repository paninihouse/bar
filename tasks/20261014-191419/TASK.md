# Make block timer start and stop predictable

- STATUS: OPEN
- PRIORITY: 40
- TAGS: review,bug,core

File: Sources/bar/Models/Block.swift; lifecycle caller: Sources/bar/Views/AppDelegate.swift.

Problem: Calling start() twice creates another timer and overwrites tick without cancelling the old task. stop() only cancels the currently stored timer. This matters when users customize lifecycle behavior or apply patches.

Approach: Choose and document idempotent start semantics or explicit restart semantics. Cancel an existing timer before replacing it where appropriate; clear stored state on stop. Preserve one initial refresh per intended start and no automatic timer for nil or nonpositive intervals. Clarify whether stop means only stop ticking or also stop queued/in-flight execution, coordinating with the execution-policy task. Do not imply Task cancellation terminates a Process unless implemented.

Completion checks: Repeated start calls do not multiply periodic executions. Stop prevents later ticks, including after a sleeping timer resumes. Start-stop-start behaves consistently. Add a small meaningful lifecycle test using short controlled intervals or an execution seam.

Design constraint: Follow README.md: keep source-based configuration, no dependencies or plugin framework, and use the smallest readable change that makes the existing behavior reliable. This is a suggestion for individual review, not a deadline. Findings were recorded on 2026-10-14; re-check the current code before implementing.
