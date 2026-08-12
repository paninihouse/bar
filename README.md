<h1 align="center">bar</h1>

<p align="center">
	<strong>Modular status bar for the Mac.</strong><br>
	<i>Minimal, elegant, customisable.</i>
</p>

<p align="center">
	<img alt="bar screenshot" src="Sources/bar/bar.docc/bar.png" width="100%">
</p>

<p align="center">
	<a href="https://github.com/paninihouse/bar/blob/master/LICENSE"><img src="https://img.shields.io/github/license/paninihouse/bar.svg" alt="GitHub license"></a>
	<img src="https://img.shields.io/badge/platform-macOS-green.svg" alt="Platform">
	<a href="https://panini.house"><img src="https://img.shields.io/badge/maintainer-Panini%20House-blue" alt="Maintainer"></a>
	<a href="https://docs.panini.house/bar"><img src="https://img.shields.io/badge/documentation-bar-blue" alt="Documentation"></a>
</p>

All the status bars we tried felt wrong in one way or another, so we decided to make our own.
Here is what you should know about *bar* before you start:

- **Just different** — *bar* doesn't work like most other bars or programs for what matters.
You configure it by directly changing the source code and tinkering with Swift files.
At the end, everyone will have their own *bar*.
- **Dead simple** — *bar* always looks for simplicity, both in usage and in the source code.
It just does the very basics very well; everything else is left out.
It doesn't even include gaps between blocks.
- **Easy to understand** — *bar*'s codebase is just ~500 lines of Swift, wrapped in a ton of comments.
Everything is explained so you can truly own the codebase and customise it as you see fit.

> This is not software you install, run, and forget about.
> You're supposed to understand how it works, customise it, and ultimately give back enhancements to the community.

`bar` was inspired by some great [suckless tools](https://suckless.org/) like [dwmblocks](https://github.com/LukeSmithxyz/dwmblocks).

---

## Features

### Simple configuration

Define a **block** by specifying a name, placement, shell command, and an optional refresh interval:

```swift
static let blocks: [Block] = [
	Block(name: "spaces", placement: .left,  command: "~/.local/scripts/bar/spaces.sh"),
	Block(name: "app",    placement: .left,  command: "~/.local/scripts/bar/app.sh"),
	Block(name: "mail",   placement: .right, command: "~/.local/scripts/bar/mail.sh",  interval: 10),
	Block(name: "volume", placement: .right, command: "~/.local/scripts/bar/volume.sh"),
	Block(name: "clock",  placement: .right, command: "~/.local/scripts/bar/clock.sh", interval: 60),
]
```

### Intuitive shell scripting

Populate the block by writing to `stdout`, hide it by exiting with `0`:

```shell
if [[ -n $session ]]; then
	echo $session
else
	exit 0
fi
```

### Gestures

React to clicks and scrolls with the `BUTTON` and `SCROLL` environment variables:

```shell
case $BUTTON in
	(0) mpc toggle ;;
	(1) mpc stop   ;;
esac

case $SCROLL in
	(UP)   increaseVolume ;;
	(DOWN) decreaseVolume ;;
esac
```

### Highlighting

Prefix the output with `&!<level>` to apply a background color from the `highlights` array (defined in Config):

```shell
echo "&!1 $(date '+%a %d, %H:%M') "    # highlighted with highlights[0]
```

### Manual refresh

Refresh a block at any time, regardless of its interval, by sending a standard **Darwin notification**:

```shell
notifyutil -p bar.touch.<block-name>
```

### Multi cell output

Every line of `stdout` becomes one **cell** in the block.
Great for building grouped content like a workspace indicator:

```shell
for workspace in "${workspaces[@]}"; do
	if [[ $workspace == $focused_workspace ]]; then
		echo "&!2 $workspace "
	else
		echo "&!1 $workspace "
	fi
done
```

---

## Get started & Full documentation

The full documentation, with a get started guide, is available at [https://docs.panini.house/bar](https://docs.panini.house/bar).
