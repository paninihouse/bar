# Commands

How a block runs its command and what you can do with it.

Each block runs its ``Config-swift.enum/Block/command`` as a shell script via `/bin/sh -c`.
The standard output is captured and **each line becomes one ``Cell``** in the bar.
Cells are laid out horizontally in the order they appear.

```shell
# A single-line command produces one cell
echo "Hello, world"

# Multi-line output produces multiple cells
echo "first cell"
echo "second cell"
```

## Highlighting cells

Prefix a line with `&!<level>` to apply a highlight background color.
The highlight level is a positive integer that indexes into ``Config-swift.enum/highlights`` (1-based).

```shell
echo "&!1 workspace 1"    # highlighted with Config.highlights[0]
echo "&!2 workspace 2"    # highlighted with Config.highlights[1]
echo "workspace 3"        # no highlight
```

Highlight colors were imagined specifically for distinguishing cells within a group. E.g: showing window manager workspaces and which one is active.

## Environment variables

Each command inherits the `bar` process environment, plus these extras:

| Variable | What holds | When set | Example value |
|---|---|---|---|
| `BLOCK` | The name of the block | Always | `"clock"` |
| `BUTTON` | The mouse button number | On mouse click inside the block | `"0"` (left), `"1"` (right), `"2"` (middle) |
| `SCROLL` | The scroll direction | On scroll over the block | `"UP"`, `"DOWN"`, `"LEFT"`, `"RIGHT"` |

This lets a single script adapt its behaviour based on which block called it or what interaction just happened:

```shell
#!/bin/sh
if [ "$BLOCK" = "clock" ]; then
    date '+%a %d, %H:%M:%S'
elif [ -n "$BUTTON" ]; then
    echo "clicked button $BUTTON"
fi
```
