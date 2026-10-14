# Command

How the block's command is executed.

Each block runs its ``Config-swift.enum/Block/command`` as a shell script via `/bin/sh -c`.
The standard output is captured and **each line becomes one ``Cell``** in the bar.
Cells are laid out horizontally in the order they appear.
One final newline is removed; other blank lines and spaces are preserved.
A successful command with empty stdout produces no cells, hiding the block.
Printing a newline produces a blank cell rather than hiding it.

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
After a non-zero exit, captured stderr is forwarded to the `bar` process stderr.
Stderr from a successful command is discarded, and launch failures do not forward a diagnostic.
Successful stdout that cannot be decoded as UTF-8 produces a blank cell.

After 30 seconds, *bar* requests termination of the shell with SIGTERM.
This is not a hard deadline: a shell can ignore the signal, and child processes can keep the output pipes open.
The current runner reads stdout and then stderr before waiting for exit, so commands with enough stderr output can also block while stdout is being read.

```shell
# Example: simulate a command failure
some-command-that-fails && echo "&!1 success"
```

> Tip: If you see `ERROR` in the bar, run the command manually in your terminal to diagnose the issue.
