# Volume

A script that prints the current volume level.

```shell
#!/bin/zsh

increaseVolume() { osascript -e "set volume output volume (output volume of (get volume settings) + 5)" }
decreaseVolume() { osascript -e "set volume output volume (output volume of (get volume settings) - 5)" }
toggleMuted() {
	case $(osascript -e "output muted of (get volume settings)") in
		(true)  osascript -e "set volume output muted false" ;;
		(false) osascript -e "set volume output muted true" ;;
	esac
}

case $BUTTON in
	(2) toggleMuted ;;
esac

case $SCROLL in
	(UP)  increaseVolume ;;
	(DOWN) decreaseVolume ;;
esac

volume=$(osascript -e "output volume of (get volume settings)")
muted=$(osascript -e "output muted of (get volume settings)")

if [[ $muted == true ]]; then
	icon="􀊣"
else
	case $volume in
		[6-9][0-9]|100)   icon="􀊩" ;;
		[3-5][0-9])       icon="􀊧" ;;
		[1-9]|[1-2][0-9]) icon="􀊥" ;;
		*)                icon="􀊣" ;;
	esac
fi

echo " $icon $volume% "
```

> Note: The block will increase/decrease the volume on scroll and mute/un-mute on scroll-wheel click.

## Usage

Instead of relaying on ``Block/interval``, you might want to use the <doc:daemon-volumed> daemon to update the block in real-time.
