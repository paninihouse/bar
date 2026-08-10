# Installation

How to install and build the program.

**Building the program from source is an integral part of the philosophy and design of the software**.
For this reason we do not ship pre-built binaries nor you'll be able to find it on Homebrew or any other package manager.

## Requirements

- **macOS 26** or later
- **Swift 6.3** (bundled with Xcode or installed via [swift.org](https://swift.org))

## Download

Clone the official repository somewhere on you system:

```shell
git clone https://github.com/paninihouse/bar.git
```

## Build

From within the *bar* directory, run the install target:

```shell
make install
```

> Tip: By default, the install target builds a release binary and copies it to `~/.local/bin/bar`.
> You can override the install location by setting `PREFIX`:
>
> ```shell
> make install PREFIX=/usr/local/bin
> ```

### Without make

If you don't have `make`, build directly with the Swift Package Manager:

```shell
swift build -c release
cp .build/release/bar /usr/local/bin/
```

## Run at login

It is fine to run `bar` manually while you're editing and customising the source code.
Although, as soon as you're happy with your build is a good idea to create a launch agent that can start the program for you.

Copy the example down below in a `plist` file inside the `~/Library/LaunchAgents/` directory.

> Tip: It is best practice to use [reverse domain name notation](https://en.wikipedia.org/wiki/Reverse_domain_name_notation) for the filename.

Adjust the example as you see fit.
For the full file specification run:

```shell
man launchd.plist
```

You can than register the launch agent like so:

```shell
launchctl load ~/Library/LaunchAgents/house.panini.bar.plist
```

### Example launch agent

```plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>house.panini.bar</string>

	<key>ProgramArguments</key>
	<array>
		<string>~/.local/bin/bar</string>
	</array>

	<key>RunAtLoad</key>
	<true/>

	<key>KeepAlive</key>
	<true/>

	<key>StandardOutPath</key>
	<string>/tmp/bar/bar.log</string>

	<key>StandardErrorPath</key>
	<string>/tmp/bar/bar.err</string>
</dict>
</plist>
```
