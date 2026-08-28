# Run at login

How to start the program automatically at login.

It is fine to run `bar` manually while you're editing and customising the source code.
Although, as soon as you're happy with your build is a good idea to integrate `bar` with your window manager or create a launch agent that can start the program for you.

## Using yabai

If you are using [yabai](https://github.com/asmvik/yabai), add this line **at the very end** of your `yabairc` to start `bar` alongside the window manager:

```sh
# ~/.config/yabai/yabairc

killall bar 2>/dev/null; bar &
```

## Using AeroSpace

If you are using [AeroSpace](https://github.com/nikitabobko/AeroSpace), add an **after startup command** to start `bar` alongside the window manager:

```toml
# ~/.config/aerospace/aerospace.toml

after-startup-command = [
  "exec-and-forget bash -c 'killall bar 2>/dev/null; bar &'"
]
```

## Using a launch agent

If you want to run `bar` independently from a window manager, you can create a launch agent that runs it at login.
Copy this code in a `plist` file inside the `~/Library/LaunchAgents/` directory.

> Tip: It is best practice to use [reverse domain name notation](https://en.wikipedia.org/wiki/Reverse_domain_name_notation) for the filename.
E.g: `house.panini.bar.plist`

> Important: Replace the two `[USER]` placeholders with your actual username.

```plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>house.panini.bar</string>

	<key>ProgramArguments</key>
	<array>
		<string>/Users/[USER]/.local/bin/bar</string>
	</array>

	<key>RunAtLoad</key>
	<true/>

	<key>KeepAlive</key>
	<true/>

	<key>StandardOutPath</key>
	<string>/Users/[USER]/.local/state/bar/bar.out.log</string>

	<key>StandardErrorPath</key>
	<string>/Users/[USER]/.local/state/bar/bar.err.log</string>
</dict>
</plist>
```

### Activate the agent

You can than register the launch agent like so:

```shell
launchctl load ~/Library/LaunchAgents/house.panini.bar.plist
```
