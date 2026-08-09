import SwiftUI

/// A color described by a hexadecimal color code.
///
/// `HEX` is a lightweight, string-backed representation: the code is stored
/// verbatim and parsed only when converted to a SwiftUI color via `Color(hex:)`
/// or `Color.hex(_:)`, which resolve it in the sRGB color space.
///
/// Supported formats (the leading `#` is optional):
/// - `#RGB`
/// - `#RGBA`
/// - `#RRGGBB`
/// - `#RRGGBBAA`
///
/// Single-digit components are expanded by repeating the digit; for example,
/// `#3aF` is read as `#33AAFF`. When present, the trailing digits encode alpha
/// (opacity); otherwise opacity defaults to `1`.
struct HEX {
	/// The raw hex code, exactly as supplied. It is not validated or normalized;
	/// parsing is performed lazily by `Color.hex(_:)`.
	var code: String

	/// Creates a hex color from the given code.
	///
	/// - Parameter code: A hex color code. Stored verbatim; see ``HEX`` for the
	///                   accepted formats.
	init(code: String) {
		self.code = code
	}
}

extension SwiftUI.Color {
	/// Creates a color from a ``HEX`` value.
	init(hex: HEX) {
		self = .hex(hex.code)
	}

	/// Creates a color from a hex code, resolving it in the sRGB color space.
	///
	/// Supported formats (the leading `#` is optional): `#RGB`, `#RGBA`,
	/// `#RRGGBB`, and `#RRGGBBAA`. Single-digit components are expanded by
	/// repeating the digit. When present, the trailing digits encode alpha
	/// (opacity); otherwise opacity defaults to `1`. Malformed input resolves
	/// to opaque black.
	///
	/// - Parameter code: A hex color code.
	static func hex(_ code: String) -> SwiftUI.Color {
		var sanitized = code.trimmingCharacters(in: .whitespacesAndNewlines)
		if sanitized.hasPrefix("#") {
			sanitized.removeFirst()
		}

		var rgba: UInt64 = 0
		Scanner(string: sanitized).scanHexInt64(&rgba)

		let red: Double
		let green: Double
		let blue: Double
		let opacity: Double

		switch sanitized.count {
		case 8:  // RRGGBBAA
			red = Double((rgba >> 24) & 0xFF) / 255.0
			green = Double((rgba >> 16) & 0xFF) / 255.0
			blue = Double((rgba >> 8) & 0xFF) / 255.0
			opacity = Double(rgba & 0xFF) / 255.0
		case 6:  // RRGGBB
			red = Double((rgba >> 16) & 0xFF) / 255.0
			green = Double((rgba >> 8) & 0xFF) / 255.0
			blue = Double(rgba & 0xFF) / 255.0
			opacity = 1.0
		case 4:  // RGBA
			red = Double(((rgba >> 12) & 0xF) * 0x11) / 255.0
			green = Double(((rgba >> 8) & 0xF) * 0x11) / 255.0
			blue = Double(((rgba >> 4) & 0xF) * 0x11) / 255.0
			opacity = Double((rgba & 0xF) * 0x11) / 255.0
		case 3:  // RGB
			red = Double(((rgba >> 8) & 0xF) * 0x11) / 255.0
			green = Double(((rgba >> 4) & 0xF) * 0x11) / 255.0
			blue = Double((rgba & 0xF) * 0x11) / 255.0
			opacity = 1.0
		default:
			red = 0.0
			green = 0.0
			blue = 0.0
			opacity = 1.0
		}

		return Color(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
	}
}

extension SwiftUI.Color.Resolved {
	/// The hex code for this resolved color.
	///
	/// Components are clamped to `0...1` and quantized to 8 bits.
	/// The result is a 6-digit `#RRGGBB` code, or an 8-digit `#RRGGBBAA` code
	/// when the color is not fully opaque.
	var hex: HEX {
		let r = Int((min(max(Double(red), 0), 1) * 255).rounded())
		let g = Int((min(max(Double(green), 0), 1) * 255).rounded())
		let b = Int((min(max(Double(blue), 0), 1) * 255).rounded())

		let code: String
		if opacity < 1 {
			let a = Int((min(max(Double(opacity), 0), 1) * 255).rounded())
			code = String(format: "#%02X%02X%02X%02X", r, g, b, a)
		} else {
			code = String(format: "#%02X%02X%02X", r, g, b)
		}

		return HEX(code: code)
	}
}
