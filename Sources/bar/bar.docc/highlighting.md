# Highlighting

Change the background color of a block's cell on-demand.

You can assign a background color to each ``Cell`` within a ``Block`` directly from the shell script.
Since the colors are assigned at runtime, highlights can be used not only for customising the appearance but also for assigning meaning or status to a particular item of the bar.

Also, since the color is applied to a single cell and not to the entire block, this feature is perfect for building grouped content like a workspace indicator or any other situation where you want to see which item is selected within a group.

## Define the highlights

Before assigning a color to a cell, you have to define the available ``Config-swift.enum/highlights`` in the ``Config`` file.

```swift
// Sources/bar/Config.swift

enum Config {
	static let highlights: [Color] = [.hex("#ff0000"), .hex("#0000ff"), .purple]
}
```

> Note: The order in which you define the highlights matters.
*bar* will use the index of the elements in the array as the "level" of highlight you want to apply.
See [set the highlight](#Set-the-highlight) for more information.

## Set the highlight

In a shell script, prefix an output line with `&!<level>` to apply the desired highlight.
You are not required to leave an empty space after special notation.

```shell
echo "&!1 workspace 1"    # highlighted with Config.highlights[0]
echo "&!2 workspace 2"    # highlighted with Config.highlights[1]
echo "workspace 3"        # no highlight
```

> Important: Only a prefix at the start of the line is recognized. Its level uses ASCII digits (`0`–`9`), and the entire digit sequence is consumed. A nonempty body must follow it. Whitespace counts as a body and is preserved exactly: `&!1 workspace 1` renders as ` workspace 1`, including the leading space.

The highlight level is a positive integer that indexes into ``Config-swift.enum/highlights`` (1-based).
With a nonempty body, zero, an out-of-range level, or an integer overflow removes the prefix but leaves the body unhighlighted.
Leading zeroes are allowed (`&!01 text` selects level 1).

Empty input, textless prefixes such as `&!1` and `&!12`, and malformed prefixes such as `&!`, `&!-1 text`, or `&!１ text` remain literal and unhighlighted.
Embedded prefixes also remain literal, as in `text &!1 more`.
