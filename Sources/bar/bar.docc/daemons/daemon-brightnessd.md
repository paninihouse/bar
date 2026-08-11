# brightnessd

React to display brightness changes.

This daemon listens for display brightness changes via **IOKit** and posts a Darwin notification that tells *bar* to refresh the desired block.
It fires when the brightness level changes through keyboard keys, the Touch Bar, or System Settings.

## How it works

The daemon uses IOKit notifications to watch for changes to the display backlight service (`AppleBacklightDisplay` or `AppleIntelPanel`).
When the brightness changes, the daemon calls `notify_post("bar.touch.<block-name>")`.

The ``Notifier`` system in *bar* picks this up and re-runs the block's command.

### Dependencies

- IOKit.framework, CoreFoundation.framework

## Compile

```shell
cc -o bar-brightnessd daemons/brightnessd.c -framework IOKit -framework CoreFoundation
```

## Author

Tommaso Negri [@tommasongr](https://github.com/tommasongr)
