# nowplayingd

React to music track changes.

This daemon listens for track change notifications from **Music** and **Spotify** via `DistributedNotificationCenter` and posts a Darwin notification that tells *bar* to refresh the desired block.

## How it works

The daemon registers distributed notification observers for:
- `com.apple.Music.playerInfo` — fired by Music.app when the track changes.
- `com.spotify.client.PlaybackStateChanged` — fired by Spotify when the track changes.

When either notification fires, the daemon calls `notify_post("bar.touch.<block-name>")`.

The ``Notifier`` system in *bar* picks this up and re-runs the block's command, which can read the current track from any source.

### Dependencies

- CoreFoundation.framework

### Compile

```shell
cc -o bar-nowplayingd daemons/nowplayingd.c -framework CoreFoundation
```

## Author

Tommaso Negri [@tommasongr](https://github.com/tommasongr)
