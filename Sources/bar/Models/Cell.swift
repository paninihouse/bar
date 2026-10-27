import SwiftUI

/// A thin wrapper around a single text line captured
/// by a block.
///
/// When a ``Block`` executes the command it captures `stdout`
/// and splits each line into a ``Cell``. Each ``Cell``
/// is then laid out horizontally respecting the order.
///
/// ### Highlight
/// Besides the underlying text value, a cell holds a background
/// color selected by a highlight level from ``Config``.
/// You can set the highlight at runtime by prefixing the
/// text line with the special notation `&!<level>`, where
/// `<level>` is a positive integer that can be used as an
/// index to pick an highlight.
///
/// ```shell
/// echo "&!1 $(date "+%a %d, %H:%M:%S") "
/// ```
///
/// > Note: Count starts from 1.
///
/// Highlight colors can have multiple use cases, but they
/// were imagined specifically for distinguishing cells
/// within a group. For example when you want to show
/// window manager workspaces and which one is active.
struct Cell: RawRepresentable, Identifiable {
	/// A content-derived identifier combining text and highlight.
	///
	/// Identical cells share this value and content changes change it.
	/// ``BlockView`` uses line positions to distinguish rendered cells;
	/// view identity does not prevent updates to their displayed content.
	let id: String

	/// The represented text content.
	let rawValue: String

	/// The background color of the cell derived from the highlight level.
	var background: Color

	init(rawValue: String) {
		var text = rawValue
		var level = 0

		if rawValue.hasPrefix("&!") {
			let suffix = rawValue.dropFirst(2)
			// Consume every ASCII digit before interpreting the level.
			let digits = suffix.prefix { character in
				character.unicodeScalars.count == 1 && character >= "0" && character <= "9"
			}
			let body = suffix.dropFirst(digits.count)
			if !digits.isEmpty && !body.isEmpty {
				text = String(body)
				if let parsed = Int(digits), parsed > 0, parsed <= Config.highlights.count {
					level = parsed
				}
			}
		}

		self.rawValue = text
		self.background = level > 0 ? Config.highlights[level - 1] : .clear
		self.id = "\(text):\(level)"
	}
}
