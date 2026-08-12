# MPD

A script that prints the current artist and song from MPD.

```shell
#!/bin/zsh

case $BUTTON in
	(0) mpc toggle >/dev/null ;;
	(2) mpc stop   >/dev/null ;;
esac

artist=$(mpc current -f %artist% 2>/dev/null)
song=$(mpc current -f %title% 2>/dev/null)

# Nothing playing → hide block
if (( $(mpc status 2>/dev/null | wc -l) == 1 )); then
	exit 0
elif mpc status 2>/dev/null | awk 'NR==2 {print; exit}' | grep -q playing; then
	echo " 􀊆 $artist • $song "
else
	echo " 􀊄 $artist • $song "
fi
```

> Note: The block will play/pause the song on left mouse click and stop the player on scroll-wheel click.

## Usage

Instead of relaying on ``Block/interval``, you might want to use the <doc:daemon-mpd> daemon to update the block in real-time.
