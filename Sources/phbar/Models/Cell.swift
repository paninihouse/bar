import Foundation
import RegexBuilder
import SwiftUI

/// A thin wrapper around a single text line captured
/// by a block.
///
/// When a block executes the command it captures stdout
/// and splits each line into a cell. Each cell is then
/// laid out horizontally respecting the order.
///
/// Besides the underlying text value, a cell holds an
/// highlight level (as Int) that, if true, applies the
/// special background color defined in `Config.swift`.
/// You can set the highlight at runtime by prefixing the
/// text line with the special notation `&!<level>`, where
/// `<level>` is a positive integer that can be used as an
/// index to pick an highlight (count starts from 1).
///
/// E.g: `echo "&!1 $(date "+%a %d, %H:%M:%S") "`
///
/// Highlight colors can have multiple use cases, but they
/// were imagined specifically for distinguishing cells
/// within a group. For example when you want to show
/// window manager workspaces and which one is active.
struct Cell: RawRepresentable, Identifiable {
	/// Stable identity for SwiftUI diffing.
	let id = UUID()

	/// The represented text content.
	let rawValue: String

	/// The highlight level of the cell.
	let highlight: Int

	/// The background color derived from the highlight level.
	///
	/// Returns the `Config.highlights` color at the same index
	/// if present, otherwise `.clear` so the underlying bar
	/// background shows through.
	var background: Color {
		guard highlight != 0 && highlight <= Config.highlights.count else { return .clear }

		return Config.highlights[highlight - 1]
	}

	init(rawValue: String) {
		let pattern = Regex {
			Optionally {
				"&!"
				Capture { OneOrMore(.digit) }
			}
			Capture { OneOrMore(.any) }
		}

		guard let match = rawValue.firstMatch(of: pattern) else {
			self.rawValue = rawValue
			self.highlight = 0
			return
		}

		if let rawHighlight = match.output.1, let highlight = Int(String(rawHighlight)) {
			self.highlight = highlight
		} else {
			self.highlight = 0
		}

		self.rawValue = String(match.output.2)
	}
}
