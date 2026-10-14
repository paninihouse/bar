# Validate complete hex color input

- STATUS: CLOSED
- PRIORITY: 160
- TAGS: review,bug,core

File: Sources/bar/Models/HEX.swift; add small color/parser tests if useful.

Problem: Scanner.scanHexInt64's result and final position are ignored. Partial valid prefixes can be accepted. Inputs with supported length but invalid characters can produce colors other than the documented opaque-black fallback, including transparency for RGBA forms.

Approach: Validate every character and require complete successful conversion before component extraction. Consider UInt64(radix: 16) or checking Scanner success and exhaustion; retain only the small implementation needed. Preserve optional #, surrounding whitespace handling, case-insensitive hex, supported lengths 3/4/6/8, repeated short digits, and trailing alpha. Define malformed input consistently as opaque black.

Completion checks: Valid short and long RGB/RGBA resolve correctly, including lowercase and alpha. Invalid characters at the start/middle/end, unsupported lengths, empty input, and partial scans all resolve to opaque black. Keep parsing independent of any new configuration framework and verify existing Config colors retain their appearance.

Design constraint: Follow README.md: keep source-based configuration, no dependencies or plugin framework, and use the smallest readable change that makes the existing behavior reliable. This is a suggestion for individual review, not a deadline. Findings were recorded on 2026-10-14; re-check the current code before implementing.

## Completion

Updated the retained helper in Sources/bar/Models/Color+Hex.swift (HEX.swift was
removed by task 20261014-192305). Validate all characters as ASCII hexadecimal
digits and require complete UInt64(radix: 16) conversion before extracting
components. Unsupported lengths and malformed input consistently return opaque
sRGB black. Optional #, surrounding whitespace, letter case, repeated short
digits, trailing alpha, and Config appearance are preserved. Updated the helper
comment and customization documentation to state the fallback.

Added ColorHexTests covering all four valid formats, mixed case, whitespace,
transparent and opaque alpha, 27 malformed inputs including invalid characters
at start/middle/end and partial scans, and the configured colors' resolved RGBA.
Validation: swift test passed all seven tests (including 27 malformed-input
cases); the clean DocC workflow built the app and documentation without warnings;
git diff --check passed.
