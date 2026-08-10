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

> Tip: While iterating on the configuration, use `make run` instead.
> It builds and runs the program in one step without copying the binary, which speeds up the edit-compare loop.

### Without make

If you don't have `make`, build directly with the Swift Package Manager:

```shell
swift build -c release
cp .build/release/bar /usr/local/bin/
```
