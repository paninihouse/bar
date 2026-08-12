# Aerospace

A script that prints the active Aerospace workspaces.

```shell
#!/bin/zsh

# Get all available workspaces
workspaces=()
while IFS= read -r line; do
	workspaces+=("$line")
done < <(aerospace list-workspaces --monitor 1)

# Get all active workspaces (with at least one window).
typeset -A used_workspaces
while IFS= read -r line; do
	used_workspaces[$line]=1
done < <(aerospace list-windows --monitor 1 --format "%{workspace}")

# Get the current workspace
focused_workspace=$(aerospace list-workspaces --focused)

for workspace in "${workspaces[@]}"; do
	if [[ $workspace == $focused_workspace ]]; then
		echo "&!2 $workspace "
	elif [[ -n ${used_workspaces[$workspace]} ]]; then
		echo "&!1 $workspace "
	fi
done
```

## Usage

Instead of relaying on ``Block/interval``, you might want to setup a Aerospace [callback](https://nikitabobko.github.io/AeroSpace/guide#on-focus-changed-callbacks) to update the block in real-time:

```toml
# ~/.config/aerospace/aerospace.toml

on-focus-changed = [
	"exec-and-forget notifyutil -p bar.touch.spaces"
]
```
