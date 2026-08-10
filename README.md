<h1 align="center">bar</h1>

<p align="center">
	<strong>Modular status bar for the Mac.</strong><br>
	<i>Minimal, elegant, customisable.</i>
</p>

<p align="center">
	<img alt="bar screenshot" src="Sources/bar/bar.docc/bar.png" width="100%">
</p>

---

## Philosophy

`bar` is inspired by the [suckless tools](https://suckless.org/) philosophy:

- **No configuration files** — edit `Config.swift`, rebuild, done.
- **No plugin/extension system** — the source _is_ your configuration.
- **No pre-built binaries** — you build it, you own it.
- **Tiny codebase** — the entire program is ~600 lines of Swift. Read it, understand it, make it yours.

> This is not software you install, run, and forget about.
> You're supposed to understand how it works, customise it, and ultimately give back enhancements to the community.

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

Full documentation is available as a [DocC archive](https://github.com/paninihouse/bar) or by running:

```shell
make docs
```

It covers installation, customisation, blocks, highlighting, gestures, refresh, patches, and more.

---

## Patches

Following the suckless tradition, `bar` is extended via **patches** — minimal, focused diffs that you apply to the source and rebuild.

Browse the available patches in the [patches directory](patches/).

| Patch | Description |
|---|---|
| [font-offset](patches/bar-font_offset-20260810-11d813c.patch) | Adjust vertical text centering |
| [screen-hotplug](patches/bar-screen_hotplug-20260810-f6805c9.patch) | Auto-rebuild windows when displays are added/removed |

To apply a patch:

```shell
curl -sL https://raw.githubusercontent.com/paninihouse/bar/refs/heads/master/patches/bar-screen_hotplug-20260810-f6805c9.patch | patch -p1
make install
```

> Want to share your own patch? Create a focused diff (`git diff > my-feature.patch`), upload it, and open a PR linking it in the docs.

---

## License

[MIT](LICENSE)
