# Multi-screen

How the bar behaves when more than one display is connected.

At launch, *bar* creates one bar for **each screen** connected to your Mac.
Every bar spans the full width of its own screen and is anchored at the top or bottom edge, depending on the ``Config-swift.enum/position`` setting.
All bars display the same set of ``Block``, so each screen mirrors the others.

You don't need to configure anything per-display: every bar is built from the same ``Config``, and the ``Screen`` type sizes it automatically to fit its screen's frame.
This also means that bars on displays with different resolutions are sized to match each screen.

## Adding or removing displays

Bars are created when the program starts, based on the screens connected at that moment.
If you connect or disconnect a display while the program is already running, *bar* does **not** automatically add or remove a bar for it.
To pick up the new screen layout, restart the program.

> Note: Handling display hot-plugging at runtime is not part of the core, but the screen code is small and self-contained, which makes it a good candidate for a custom <doc:patches>.