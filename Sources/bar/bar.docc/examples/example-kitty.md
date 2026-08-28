# Kitty sessions

A script that prints the current Kitty session.

## Using yabai

```shell
#!/bin/zsh

# Get currently focused app
app=$(yabai -m query --windows | jq -r '.[] | select(."has-focus" == true) | .app')

if [[ $app == kitty ]]; then
	# Get current kitty session
	socket=$(ls -t /tmp/kitty-* 2>/dev/null | head -1)
	[[ -z $socket ]] && exit 0
	session=$(kitty @ --to "unix:$socket" ls | jq -r '.[0].tabs[] | select(.is_active).windows[] | select(.is_active).session_name')

	if [[ -n $session ]]; then
		echo " ($session)"
	else
		exit 0
	fi
else
	exit 0
fi
```

### Usage

Instead of relaying on ``Block/interval``, you might want to setup a Kitty [watcher](https://sw.kovidgoyal.net/kitty/launch/#watchers) to update the block in real-time:

```python
# ~/.config/kitty/watchers/session_watcher.py

import subprocess
from typing import Any

from kitty.boss import Boss
from kitty.window import Window

def _touch_bar() -> None:
    subprocess.Popen(
        ["notifyutil", "-p", "bar.touch.session"],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )

def on_focus_change(boss: Boss, window: Window, data: dict[str, Any]) -> None:
    _touch_bar()

def on_tab_bar_dirty(boss: Boss, window: Window, data: dict[str, Any]) -> None:
    _touch_bar()
```

Also, you might want to refresh the block on workspace/app change.
You can do that by setting a yabai [signal](https://github.com/asmvik/yabai/wiki/Commands#automation-with-rules-and-signals):

```toml
# ~/.config/yabai/yabairc

yabai -m signal --add event=window_focused action='notifyutil -p bar.touch.session'
```

## Using AeroSpace

```shell
#!/bin/zsh

# Get currently focused app
app=$(aerospace list-windows --focused --format "%{app-name}")

if [[ $app == kitty ]]; then
	# Get current kitty session
	socket=$(ls -t /tmp/kitty-* 2>/dev/null | head -1)
	[[ -z $socket ]] && exit 0
	session=$(kitty @ --to "unix:$socket" ls | jq -r '.[0].tabs[] | select(.is_active).windows[] | select(.is_active).session_name')

	if [[ -n $session ]]; then
		echo " $session "
	else
		exit 0
	fi
else
	exit 0
fi
```

### Usage

Instead of relaying on ``Block/interval``, you might want to setup a Kitty [watcher](https://sw.kovidgoyal.net/kitty/launch/#watchers) to update the block in real-time:

```python
# ~/.config/kitty/watchers/session_watcher.py

import subprocess
from typing import Any

from kitty.boss import Boss
from kitty.window import Window

def _touch_bar() -> None:
    subprocess.Popen(
        ["notifyutil", "-p", "bar.touch.session"],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )

def on_focus_change(boss: Boss, window: Window, data: dict[str, Any]) -> None:
    _touch_bar()

def on_tab_bar_dirty(boss: Boss, window: Window, data: dict[str, Any]) -> None:
    _touch_bar()
```

Also, you might want to refresh the block on workspace/app change.
You can do that by setting an Aerospace [callback](https://nikitabobko.github.io/AeroSpace/guide#on-focus-changed-callbacks):

```toml
# ~/.config/aerospace/aerospace.toml

on-focus-changed = [
	"exec-and-forget notifyutil -p bar.touch.session"
]
```
