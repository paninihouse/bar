# devicesd

React to USB device hotplug events.

This daemon listens for USB device connect and disconnect events via **IOKit** and posts a Darwin notification that tells *bar* to refresh the desired block.
It fires when you plug in or unplug any USB device, including Bluetooth controllers.

## How it works

The daemon uses IOKit matching notifications to watch for:
- `IOUSBDevice` — USB device connect and disconnect events.
- `IOBluetoothHCIController` — Bluetooth controller events.

When a device is added or removed, the daemon calls `notify_post("bar.touch.<block-name>")`.

The ``Notifier`` system in *bar* picks this up and re-runs the block's command.

### Dependencies

- IOKit.framework, CoreFoundation.framework

## Compile

```shell
cc -o bar-devicesd daemons/devicesd.c -framework IOKit -framework CoreFoundation
```

## Author

Tommaso Negri [@tommasongr](https://github.com/tommasongr)
