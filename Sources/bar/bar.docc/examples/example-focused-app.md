# Focused app

A script that prints the currently focused app with a custom icon.

> Important: This script uses Aerospace CLI to get the currently focused window.
If you don't use Aerospace, please adapt the script accordingly.

```shell
#!/bin/zsh

# Default to a UTF-8 locale when launched with a minimal environment
# (aerospace/launchd set neither LANG nor LC_*), otherwise zsh rejects
# multibyte chars like the U+200E prefix in WhatsApp's app-name.
: ${LANG:=en_US.UTF-8}; export LANG

# Icon used when the focused app isn't recognised below
fallback_icon="􀿩"

# Get currently focused app
app=$(aerospace list-windows --focused --format "%{app-name}")

# Hide app on an empty workspace
if [[ -z $app ]]; then
	echo ""
	exit 0
fi

# Map each favourite app to its SF Symbol icon, grouped by icon.
typeset -A icons
map() {
	local icon=$1; shift
	for name in "$@"; do icons[$name]=$icon
	done
}

map 􀈖      Finder Transmit
map 􀙅      kitty Xcode "SF Symbols" Terminal TablePro RapidAPI
map 􀎭      qutebrowser "Brave Browser" Safari
map 􀑊      "Brewer X" "App Store"
map 􀌥      Messages WhatsApp $'\u200eWhatsApp' # WhatsApp ships a leading U+200E (invisible LRM)
map 􀍊      Whereby FaceTime "Final Cut Pro" HandBrake Compressor Infuse TV mpv
map 􀉉      BusyCal Calendar
map 􀉭      BusyContacts
map 􁖇      Sketch
map 􀤑      "Pixelmator Pro" Affinity Aseprite
map 􀆃      Calculator
map 􀣉      Numbers
map 􁅌      Keynote "iA Presenter"
map 􀦊      Pages "iA Writer"
map 􀢅      Blender
map 􀑪      Music "Mp3tag"
map 􀊱      Podcasts
map 􀟽      "Logic Pro"
map 􀍖      Mail
map 􀋮      Preview

# Set icon (fallback to $fallback_icon for unknown apps) + label in one call, then show
echo " ${icons[$app]:-$fallback_icon} $app "
```

## Usage

Instead of relaying on ``Block/interval``, you might want to setup a Aerospace [callback](https://nikitabobko.github.io/AeroSpace/guide#on-focus-changed-callbacks) to update the block in real-time:

```toml
# ~/.config/aerospace/aerospace.toml

on-focus-changed = [
	"exec-and-forget notifyutil -p bar.touch.app"
]
```
