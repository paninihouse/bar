<h1 align="center">bar</h1>

<p align="center">
	<strong>Modular status bar for the Mac.</strong><br>
	<i>Minimal, elegant, customisable.</i>
</p>

<p align="center">
	<img alt="bar screenshot" src="Sources/bar/bar.docc/bar.png" width="100%">
</p>

All the status bar we tried felt wrong in a way or another, so we decided to make our own.
Here is what you should know about *bar* before you start:

- **Just different** — *bar* doesn't work like most other bars or programs for what matters.
You configure it by changing directly the source code and messing around with Swift files.
At the end, everyone will have their own *bar*.
- **Dead simple** — *bar* always looks for simplicity, both in usage and in the source code.
It just do the very basics very well, everything else is left out.
It doesn't even include gaps between blocks...
- **Easy to understand** — *bar* codebase is just ~500 lines of Swift, wrapped in a ton of comments.
Everything is explained so you can truly own the codebase and customise it as you see fit.

> This is not software you install, run, and forget about.
> You're supposed to understand how it works, customise it, and ultimately give back enhancements to the community.

`bar` was inspired by some great [suckless tools](https://suckless.org/) like [dwmblocks](https://github.com/LukeSmithxyz/dwmblocks).

---

## Quick start

### Requirements

- **macOS 26** or later
- **Swift 6.3** (bundled with Xcode or installed from [swift.org](https://swift.org))

### Install

```shell
git clone https://github.com/paninihouse/bar.git
cd bar
make install
```

The binary is placed at `~/.local/bin/bar` by default. Set `PREFIX` to change the location:

```shell
make install PREFIX=/usr/local/bin
```

> While iterating on your configuration, use `make run` to build and run in one step.

### Run at login

Create a launch agent so the bar starts when you log in:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>house.panini.bar</string>
	<key>ProgramArguments</key>
	<array><string>~/.local/bin/bar</string></array>
	<key>RunAtLoad</key>
	<true/>
	<key>KeepAlive</key>
	<true/>
	<key>StandardOutPath</key>
	<string>/tmp/bar/bar.log</string>
	<key>StandardErrorPath</key>
	<string>/tmp/bar/bar.err</string>
</dict>
</plist>
```

---

## Configuration

All configuration lives in `Sources/bar/Config.swift`:

```swift
enum Config {
	static let height: Double     = 30
	static let position: Position = .top

	static let font: Font = .system(size: 14, weight: .regular, design: .monospaced)

	static let foreground: Color   = .hex("#FFFFFF")
	static let background: Color   = .hex("#000000").opacity(0.75)
	static let highlights: [Color] = [.blue, .purple]

	static let blocks: [Block] = [
		Block(name: "workspaces", placement: .left,  command: "~/bin/workspaces"),
		Block(name: "clock",      placement: .right, command: "date '+%a %d, %H:%M:%S'", interval: 1),
	]
}
```

Edit the properties, rebuild with `make install`, and the bar updates immediately after restart.

> Colors can be defined with hex codes: `Color.hex("#CDD6F4")` supports `#RGB`, `#RGBA`, `#RRGGBB`, and `#RRGGBBAA` formats.

---

## Features

### Blocks and cells

Each **block** runs a shell command. Every line of stdout becomes one **cell** in the bar:

```shell
echo "first cell"
echo "second cell"
```

Blocks can refresh on an interval or on demand via a Darwin notification:

```shell
notifyutil -p bar.touch.<block-name>
```

### Highlighting

Prefix a line with `&!<level>` to apply a background color from the `highlights` array:

```shell
echo "&!1 workspace 1"    # highlighted with highlights[0]
echo "workspace 2"        # no highlight
```

### Gestures

React to clicks and scrolls on any block. The block's command receives `BUTTON` or `SCROLL` environment variables:

```shell
case $BUTTON in
	(0) mpc toggle ;;
	(1) mpc stop   ;;
esac
```

### Hide and show

```shell
notifyutil -p bar.hide     # hide all bars
notifyutil -p bar.show     # show all bars
```

### Multi-screen

A bar is created for every connected display at launch. All bars share the same configuration.

---

## Documentation

Full documentation is available at [https://docs.panini.house/bar](https://docs.panini.house/bar).
It covers installation, customisation, blocks, highlighting, gestures, refresh, patches, daemons and more.

---

## Patches

If you find `bar` too limited, you can extend it via **patches**.
They are minimal, focused diffs that you apply to the source and rebuild.

Browse the available patches in the [official documentation](https://docs.panini.house/bar/documentation/bar/patches).

---

## Daemons

Even if not directly part of `bar`, the repository contains a few daemons that you can use to refresh blocks on specific system events.

Browse the available daemons in the [official documentation](https://docs.panini.house/bar/documentation/bar/daemons).
