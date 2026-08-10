# Manual refreshes

How to trigger a block update on-demand.

*bar* implements a very basic way to manually signal a block to refresh its content.
This is done by posting a [Darwin notification](https://developer.apple.com/documentation/notifications) from the shell.

## Triggering a refresh

Use `notifyutil` (bundled with macOS) to post a notification:

```shell
notifyutil -p bar.touch.<block-name>
```

Replace `<block-name>` with the block's name (e.g. `clock`, `battery`).
If multiple blocks share the same name, a single notification refreshes them all.

## Use cases

Manual updates are useful for blocks that react to external events:

- **Window managers** - refresh when the workspace or focused app changes.
- **Volume indicator** — refresh when the sound output changes.
- **Network monitor** — poll only when the interface state flips.
- **Now playing** — update when the current track changes.

Combine with a launch agent or a shell hook that posts the notification whenever the relevant system state changes.
