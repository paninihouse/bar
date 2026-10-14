# Repair and verify the background blur patch

- STATUS: OPEN
- PRIORITY: 110
- TAGS: review,bug,patches

files: patches/patch-background_blur-20260811-10fed47.patch and sources/bar/bar.docc/patches/patch-background-blur.md.

observed: git apply --check fails against the current checkout because config context has changed. more fundamentally, the patch constructs backgroundblurview but neither the patch nor the repository defines that type; backgroundblur has no supplied implementation consuming it.

approach: choose a documented base revision, create an isolated checkout, implement the complete optional blur feature there, and regenerate the patch including any new source file. decide whether a controllable blur amount requires private apis or whether a public visual-effect view gives acceptable behavior; update the article to describe the actual implementation. keep the feature out of the core. update the filename date/base commit and every documentation link consistently.

completion checks: on a clean documented base, git apply --check succeeds, applying succeeds, and swift build succeeds. changing config.backgroundblur has the advertised effect on screen. verify transparency and window sizing. publish a complete self-contained patch; no undefined backgroundblurview or missing prerequisite remains.

design constraint: follow readme.md: keep source-based configuration, no dependencies or plugin framework, and use the smallest readable change that makes the existing behavior reliable. this is a suggestion for individual review, not a deadline. findings were recorded on 2026-10-14; re-check the current code before implementing.
