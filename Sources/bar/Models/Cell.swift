import RegexBuilder
import SwiftUI
import Synchronization

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
	/// Build the parser once rather than on every refresh of every cell.
	private static let pattern = Mutex(Regex {
		Optionally {
			"&!"
			Capture { OneOrMore(.digit) }
		}
		Capture { OneOrMore(.any) }
	})

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
		guard let match = Self.pattern.withLock({ rawValue.firstMatch(of: $0) }) else {
			self.rawValue = rawValue
			self.background = .clear
			self.id = "\(rawValue):0"
			return
		}

		guard let rawHighlight = match.output.1,
			let highlight = Int(String(rawHighlight)),
			highlight > 0,
			highlight <= Config.highlights.count
		else {
			self.rawValue = String(match.output.2)
			self.background = .clear
			self.id = "\(self.rawValue):0"
			return
		}

		self.rawValue = String(match.output.2)
		self.background = Config.highlights[highlight - 1]
		self.id = "\(self.rawValue):\(highlight)"
	}
}
