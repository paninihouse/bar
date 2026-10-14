# Validate complete hex color input

- STATUS: OPEN
- PRIORITY: 160
- TAGS: review,bug,core

File: Sources/bar/Models/HEX.swift; add small color/parser tests if useful.

Problem: Scanner.scanHexInt64's result and final position are ignored. Partial valid prefixes can be accepted. Inputs with supported length but invalid characters can produce colors other than the documented opaque-black fallback, including transparency for RGBA forms.

Approach: Validate every character and require complete successful conversion before component extraction. Consider UInt64(radix: 16) or checking Scanner success and exhaustion; retain only the small implementation needed. Preserve optional #, surrounding whitespace handling, case-insensitive hex, supported lengths 3/4/6/8, repeated short digits, and trailing alpha. Define malformed input consistently as opaque black.

Completion checks: Valid short and long RGB/RGBA resolve correctly, including lowercase and alpha. Invalid characters at the start/middle/end, unsupported lengths, empty input, and partial scans all resolve to opaque black. Keep parsing independent of any new configuration framework and verify existing Config colors retain their appearance.

Design constraint: Follow README.md: keep source-based configuration, no dependencies or plugin framework, and use the smallest readable change that makes the existing behavior reliable. This is a suggestion for individual review, not a deadline. Findings were recorded on 2026-10-14; re-check the current code before implementing.
