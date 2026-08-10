# Font offset

Adjust font centering with a vertical offset.

This patch adds a `fontOffset` option (Double) to ``Config``.
Set it to a negative value to move the text within a ``Cell`` upward, set it to a positive value to move it downward.

```swift
enum Config {
	/// The vertical offset that can be used to adjust font centering.
	///
	/// A negative value will move the text upward, while a positive
	/// value will move it downward.
	static let fontOffset: Double = -0.5
}
```

## Installation

```shell
curl -sL https://raw.githubusercontent.com/paninihouse/bar/refs/heads/master/patches/bar-font_offset-20260810-11d813c.patch | patch -p1
```

After applying, rebuild the program:

```shell
make install
```

## Author

Tommaso Negri [@tommasongr](https://github.com/tommasongr)
