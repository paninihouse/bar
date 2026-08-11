# volumed

React to volume and mute changes.

This daemon listens for system volume changes via **CoreAudio** and posts a Darwin notification that tells *bar* to refresh the desired block.
Because it uses CoreAudio's property listeners instead of an event tap, **no Accessibility permission is required**.

## How it works

The daemon registers a CoreAudio property listener on the default output device for:
- `kAudioDevicePropertyVolumeScalar` — fires when the volume level changes.
- `kAudioDevicePropertyMute` — fires when the mute state toggles.

When either property changes, the daemon calls `notify_post("bar.touch.<block-name>")`.
The ``Notifier`` system in *bar* picks this up and re-runs the block's command.

The daemon also watches for output device changes (e.g. plugging in headphones) and re-registers the listener on the new device.

### Dependencies

- CoreAudio.framework — system framework, shipped with macOS.

## Compile

```shell
cc -o bar-volumed daemons/volumed.c -framework CoreAudio
```

## Author

Tommaso Negri [@tommasongr](https://github.com/tommasongr)
