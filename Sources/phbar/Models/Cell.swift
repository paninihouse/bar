import Foundation
import SwiftUI

/// A thin wrapper around a single text line captured
/// by a block.
///
/// When a block executes the command it captures stdout
/// and splits each line into a cell. Each cell is then
/// laid out horizontally respecting the order.
///
/// Besides the underlying text value, a cell holds an
/// highlighted status that, if true, applies the special
/// background color defined in `Config.swift`.
/// You can set the highlight at runtime by prefixing the
/// text line with the special notation `!!`.
///
/// E.g: `echo "!! $(date "+%a %d, %H:%M:%S") "`
///
/// Highlight can have multiple use cases, but it was
/// imagined specifically for distinguishing a single cell
/// within a group. For example when you want to show which
/// workspace is currently active.
struct Cell: RawRepresentable, Identifiable {
	/// Stable identity for SwiftUI diffing.
	let id = UUID()

	/// The represented text content.
	let rawValue: String

	/// Whether the cell is highlighted or not.
	let highlighted: Bool

	/// The background color derived from the highlighted state.
	///
	/// Returns `Config.highlight` when the cell is highlighted,
	/// otherwise `.clear` so the underlying bar background
   /// shows through.
	var background: Color {
		highlighted ? Config.highlight : .clear
	}

	init(rawValue: String) {
		self.highlighted = rawValue.hasPrefix("!!")
		self.rawValue = highlighted ? String(rawValue.dropFirst(2)) : rawValue
	}
}
