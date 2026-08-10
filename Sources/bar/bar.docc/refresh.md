# Refresh

Refresh the block manually or on an interval.

## Based on an interval

Adjust the ``Block/interval`` (in seconds) of a ``Block`` to automatically execute the command on that base.

```swift
// Sources/bar/Config.swift

enum Config {
	static let blocks: [Block] = [
		Block(name: "clock", placement: .right, command: "date '+%a %d, %H:%M:%S'", interval: 1),
	]
}
```

## Manually

Use the standard `notifyutil` program to post a Darwin notification that forces the block to be refreshed instantly, regardless of the ``Block/interval``.

```shell
notifyutil -p bar.touch.<block-name>
```

Replace `<block-name>` with the block's name (e.g. `clock`, `battery`).

> Note: If multiple blocks share the same name, a single notification refreshes them all.
