# Customisation

How to customise the program.

The program can be customised by editing the static properties inside the ``Config`` enum.

```swift
// Sources/bar/Config.swift

enum Config {
	static let height: Double     = 30
	static let position: Position = .top

	static let font: Font = .custom("My Awesome Font", fixedSize: 14)

	static let foreground: Color   = .hex("#FFFFFF")
	static let background: Color   = .hex("#000000").opacity(0.75)
	static let highlights: [Color] = [.blue, .purple]

	static let blocks: [Block] = [
		Block(name: "workspaces", placement: .left,  command: "~/scripts/workspaces"),
		Block(name: "clock",      placement: .right, command: "date '+%a %d, %H:%M:%S'", interval: 1),
	]
}
```

> Tip: While testing the configuration you might want to use the `make run` target.
> It will build and execute the program right away, without copying the binaries.

## HEX Colors

You can use any standard SwiftUI color. For convenience, we also provide the ``HEX`` type for defining colors by hex code directly in source:

```swift
static let foreground: Color = .hex("#CDD6F4")
```

Supported formats (the leading `#` is optional): `#RGB`, `#RGBA`, `#RRGGBB`, `#RRGGBBAA`.

## Spacing

*bar* does not offer an option to customise the spacing between blocks.
We personally think that adding a space character at the end or beginning of a block is plenty enough and eliminates a bunch of possible edge cases.

> Tip: If you don't like the default space of your font you can try one of the [alternatives from the Unicode specification](https://spaces.mau.fi/).
