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

## Error handling

If the command exits with a non-zero status or cannot be launched, the block displays a single cell containing the text `ERROR`.
The command's stderr is forwarded to the `bar` process stderr, which you can inspect for the actual failure.

```shell
# Example: simulate a command failure
some-command-that-fails && echo "&!1 success"
```

> Tip: If you see `ERROR` in the bar, run the command manually in your terminal to diagnose the issue.
