# Correct macOS build and installation commands

- STATUS: OPEN
- PRIORITY: 150
- TAGS: review,bug,build,docs

Files: Makefile and Sources/bar/bar.docc/installation.md.

Problem: make run uses swift run bar -c debug, which places options after the executable where they are treated as program arguments. The install target uses GNU-style install -Dm755 even though macOS install has different -D semantics. The documented PREFIX=/usr/local/bin produces /usr/local/bin/bin because the Makefile appends /bin.

Approach: Use swift run -c debug bar. Keep install -d, followed by macOS-compatible install -m 755 with quoted source/destination paths. Quote PREFIX paths in uninstall too, so prefixes containing spaces work. Correct the example to PREFIX=/usr/local. In the manual-build instructions, create ~/.local/bin before copying. Preserve the simple Makefile and its existing prefix convention.

Completion checks: Run make build and inspect/run make run on macOS. Install into a temporary writable prefix, including one with spaces; confirm executable location and permissions and exercise uninstall only in that temporary prefix. Check docs match the exact resulting paths. Do not overwrite the user's installed bar during verification.

Design constraint: Follow README.md: keep source-based configuration, no dependencies or plugin framework, and use the smallest readable change that makes the existing behavior reliable. This is a suggestion for individual review, not a deadline. Findings were recorded on 2026-10-14; re-check the current code before implementing.
