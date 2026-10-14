import SwiftUI

extension SwiftUI.Color {
	/// Creates a color from a hex code, resolving it in the sRGB color space.
	///
	/// Supported formats (the leading `#` is optional): `#RGB`, `#RGBA`,
	/// `#RRGGBB`, and `#RRGGBBAA`. Single-digit components are expanded by
	/// repeating the digit. When present, the trailing digits encode alpha
	/// (opacity); otherwise opacity defaults to `1`. Surrounding whitespace is
	/// trimmed. Unsupported lengths or any non-hexadecimal characters resolve
	/// to opaque black.
	///
	/// - Parameter code: A hex color code.
	static func hex(_ code: String) -> SwiftUI.Color {
		var sanitized = code.trimmingCharacters(in: .whitespacesAndNewlines)
		if sanitized.hasPrefix("#") {
			sanitized.removeFirst()
		}

		// Restrict input to ASCII hex digits; integer conversion also accepts signs.
		guard sanitized.utf8.allSatisfy({
			(48...57).contains($0) || (65...70).contains($0) || (97...102).contains($0)
		}), let rgba = UInt64(sanitized, radix: 16) else {
			return Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 1)
		}

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
