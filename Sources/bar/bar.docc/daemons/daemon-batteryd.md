# batteryd

React to battery and power source changes.

This daemon listens for power source changes via **IOKit** (`IOPowerSources`) and posts a Darwin notification that tells *bar* to refresh the desired block.
It fires when the battery level changes, the charger is plugged or unplugged, or the machine enters low-power mode.

## How it works

The daemon uses `IOPSNotificationCreateRunLoopSource` to register a callback that fires every time the power source state changes.
When the callback fires, the daemon calls `notify_post("bar.touch.<block-name>")`.

The ``Notifier`` system in *bar* picks this up and re-runs the block's command.

### Dependencies

- IOKit.framework, CoreFoundation.framework

## Compile

```shell
cc -o bar-batteryd daemons/batteryd.c -framework IOKit -framework CoreFoundation
```

## Author

Tommaso Negri [@tommasongr](https://github.com/tommasongr)
