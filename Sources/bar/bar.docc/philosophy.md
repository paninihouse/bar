# Design philosophy

*bar* design is heavily inspired by the suite of [suckless tools](https://suckless.org/) for Linux.
These tools are very different from what you typically have on macOS.
They do not have configuration files, extraneous features, or a plugin/extension system.
Instead, they are focused on simplicity, frugality, and a DIY approach.

We deliberately designed *bar* to be extremely limited, specific, and easy to understand, like a suckless tool.
This is not software you install, run, and forget about.
You're supposed to fully understand how it works, make it your own, and ultimately give back your enhancements to the community.

## How customization works

*bar* does not read a configuration file somewhere on your system.
Instead, configuration happens directly in the source code by editing ``Config`` and rebuilding the software.
This approach allows us to keep the software extremely minimal and reliable, since all the possible errors are caught at build time.

## No pre-built binaries

Since the configuration requires you to modify the source code, it doesn't make sense to ship pre-built binaries of *bar*.
Therefore, you won't find it in Homebrew or in any other package manager.
The way to install *bar* is simply to download or clone the repository on your system and run <doc:installation>.

## How to extend the functionality

*bar* already does a lot out of the box, but it is deliberately more limited compared to other solutions like [SketchyBar](https://felixkratz.github.io/SketchyBar/).
What if you need a specific feature that is not available?
Well, you can build it or patch it yourself.

*bar* aims to stay focused and minimal, so it can be read through and understood in roughly half an hour.
You're more than encouraged to apply patches to extend the software, write your own features, and ultimately publish them for the entire community.

This approach is far more powerful than a plugin/extension ecosystem because you're not limited to what we, as the main developers, decide you can customize or change.
You own the source code, therefore you are free to do whatever you want.
