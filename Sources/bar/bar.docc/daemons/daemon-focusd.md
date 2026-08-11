# focusd

React to Focus and Do Not Disturb mode changes.

This daemon listens for Focus mode and DND changes via `DistributedNotificationCenter` and posts a Darwin notification that tells *bar* to refresh the desired block.

## How it works

The daemon registers a distributed notification observer for `com.apple.notificationcenter.dndprefs_changed`, which macOS fires whenever the Focus mode or Do Not Disturb state changes.

When the notification fires, the daemon calls `notify_post("bar.touch.<block-name>")`.

The ``Notifier`` system in *bar* picks this up and re-runs the block's command.

### Dependencies

- CoreFoundation.framework

### Compile

```shell
cc -o bar-focusd daemons/focusd.c -framework CoreFoundation
```

## Author

Tommaso Negri [@tommasongr](https://github.com/tommasongr)
