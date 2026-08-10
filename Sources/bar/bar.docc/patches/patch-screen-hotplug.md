# Screen hot-plug

Recreate bars when a display is connected or disconnected at runtime.

Without this patch, *bar* only creates windows for the screens connected at launch.
If you plug in or unplug a display while the program is running, nothing changes.
This patch observes the system notification for display configuration changes and rebuilds the bar windows to match the new screen layout.

All windows are closed and reopened, so every bar picks up the correct position and size for its screen.
The block content is preserved during the rebuild — there is no need to re-run commands.

## Installation

```shell
curl -sL https://raw.githubusercontent.com/paninihouse/bar/refs/heads/master/patches/bar-screen_hotplug-20260810-f6805c9.patch | patch -p1
```

After applying, rebuild the program:

```shell
make install
```

## Author

Tommaso Negri [@tommasongr](https://github.com/tommasongr)
