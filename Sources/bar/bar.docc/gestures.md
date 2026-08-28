# Gestures

React to click or scroll gestures.

Each time you click or scroll over a ``Cell``, the command is executed and you can optionally react to it.

## Environment variables

When a ``Block/command`` is executed by a gesture, a few environment variables are set to let you know what just happened.

| Variable | What holds | When set | Example value |
|---|---|---|---|
| `CELL` | The ``Cell/rawValue`` of the targeted ``Cell`` | Always | `" 1 "`, `" Fri 30, 12:30:00"`, `" 50% "`, etc |
| `BUTTON` | The mouse button number | On click | `"0"` (left), `"1"` (right), `"2"` (middle), etc |
| `SCROLL` | The scroll direction | On scroll | `"UP"`, `"DOWN"`, `"LEFT"`, `"RIGHT"` |

## React to gestures

Here an example of using the `BUTTON` variable to toggle (play/pause) or stop [mpd](https://www.musicpd.org/):

```shell
case $BUTTON in
	(0) mpc toggle >/dev/null ;;
	(2) mpc stop   >/dev/null ;;
esac
```

Here an example of using the `SCROLL` variable to adjust the volume:

```shell
increaseVolume() { osascript -e "set volume output volume (output volume of (get volume settings) + 10)" }
decreaseVolume() { osascript -e "set volume output volume (output volume of (get volume settings) - 10)" }

case $SCROLL in
	(UP)   increaseVolume ;;
	(DOWN) decreaseVolume ;;
esac
```
