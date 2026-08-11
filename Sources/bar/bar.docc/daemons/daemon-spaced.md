# spaced

React to desktop space changes.

This daemon monitors the active desktop space and posts a Darwin notification that tells *bar* to refresh the desired block.
It fires when you switch between Mission Control spaces, full-screen apps, or Stage Manager groups.

## How it works

The daemon uses a lightweight 0.5-second poll of a private CoreGraphics function (`CGSCopyActiveMenuBarDisplayIdentifier`) to detect when the active space changes.
When a change is detected, the daemon calls `notify_post("bar.touch.<block-name>")`.

The ``Notifier`` system in *bar* picks this up and re-runs the block's command.

> Note: The 0.5-second poll interval is negligible — the daemon uses near-zero CPU while idle.

### Dependencies

- CoreFoundation.framework

## Compile

```shell
cc -o bar-spaced daemons/spaced.c -framework CoreFoundation
```

## Author

Tommaso Negri [@tommasongr](https://github.com/tommasongr)
