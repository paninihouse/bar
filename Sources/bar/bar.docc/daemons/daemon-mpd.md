# mpd

React to MPD (Music Player Daemon) track changes.

This daemon connects to MPD via TCP and uses the `idle` command to block until the player state or playlist changes. When it does, it posts a Darwin notification that tells *bar* to refresh the desired block.

## How it works

MPD's protocol has an `idle` command designed exactly for this purpose. You send `idle player playlist options` and the connection blocks until something changes. No polling, no busy-waiting.

When the `idle` command returns, the daemon calls `notify_post("bar.touch.<block-name>")` and immediately re-enters idle mode.

The ``Notifier`` system in *bar* picks this up and re-runs the block's command.

### Dependencies

None — uses only standard POSIX sockets and `notify.h`, both available on every Mac.

### Configuration

The daemon respects the same environment variables as `mpc`:

- `MPD_HOST` — MPD server hostname (default: `localhost`)
- `MPD_PORT` — MPD server port (default: `6600`)

## Compile

```shell
cc -o bar-mpd daemons/mpd.c
```

## Author

Tommaso Negri [@tommasongr](https://github.com/tommasongr)
