# Command

How the block's command is executed.

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

## Environment variables

Each command inherits the `bar` process environment plus a `BLOCK` variable that holds the ``Block/name``.

> Important: Since the environment is inherited by the `bar` process, there is no guarantee that the script will always receive the same set of variables.
For example, if you run `bar` from your shell, you'll probably have available the custom `PATH` you set.
On the contrary, if you run `bar` from a launch agent, you'll probably not have the same custom `PATH` set.
