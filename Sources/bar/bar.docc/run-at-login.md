# Run at login

How to start the program automatically at login.

It is fine to run `bar` manually while you're editing and customising the source code.
Although, as soon as you're happy with your build is a good idea to create a launch agent that can start the program for you.

## Create the agent

Copy this code in a `plist` file inside the `~/Library/LaunchAgents/` directory.

> Tip: It is best practice to use [reverse domain name notation](https://en.wikipedia.org/wiki/Reverse_domain_name_notation) for the filename.
E.g: `house.panini.bar.plist`

```plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>house.panini.bar</string>

	<key>ProgramArguments</key>
	<array>
		<string>[EXECUTABLE_PATH]</string>
	</array>

	<key>RunAtLoad</key>
	<true/>

	<key>KeepAlive</key>
	<true/>

	<key>StandardOutPath</key>
	<string>/tmp/bar_[USER].out.log</string>

	<key>StandardErrorPath</key>
	<string>/tmp/bar_[USER].err.log</string>
</dict>
</plist>
```

Make the two required edits:

1. Replace `[EXECUTABLE_PATH]` with a path to the `bar` executable.
If you didn't specify a different `PREFIX` in the <doc:installation#Build> phase, this should be `~/.local/bin/bar`.

2. Replace the two `[USER]` placeholders with your actual username.

## Activate the agent

You can than register the launch agent like so:

```shell
launchctl load ~/Library/LaunchAgents/house.panini.bar.plist
```
