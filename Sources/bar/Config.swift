import SwiftUI

/// The top-level configuration for the bar.
///
/// Set appearance, define blocks, and choose the bar position here.
/// This is the primary file a user edits to customise *bar*.
enum Config {
	/// The bar height in points (pt).
	///
	/// > Tip: Set this value to 30 to match the default Mac menu bar height.
	static let height: Double = 30

	/// The bar position on the screen.
	static let position: Position = .top

	// NOTE: Customizing font
	//
	// You can use system default fonts thanks to the standard SwiftUI
	// methods and access properties. However, you can also use your
	// preferred custom font.
	//
	// E.g: `.custom("Comic Code", fixedSize: 14)`
	//
	// You may want to use a patched Nerd Font (https://www.nerdfonts.com)
	// so you can have icons in your bar. Alternatively, you can display
	// SF Symbols by copy and pasting them as glyphs.

	/// The font used for all text and icons in the bar.
	static let font: Font = .system(size: 14, weight: .regular, design: .monospaced)

	// NOTE: Customizing colors
	//
	// You can use system default colors and the standard SwiftUI
	// methods to define them. However, for convenience we added
	// support for hex colors too (see ``HEX``).
	//
	// E.g: `.hex("#000000")`

	/// The color used for texts and icons.
	static let foreground: Color = .hex("#FFFFFF")

	/// The color used for the bar background.
	static let background: Color = .hex("#000000").opacity(0.75)

	/// The colors used to highlight a cell at different levels (see ``Cell``).
	static let highlights: [Color] = [.blue, .purple]

	/// The blocks that make up the bar, listed in display order.
	///
	/// Each block is positioned on the left or right side of the bar
	/// and runs a shell command, optionally on a repeating interval.
	/// See ``Config-swift.enum/Block`` for the full configuration options.
	static let blocks: [Block] = [
		Block(name: "version", placement: .left,  command: "echo '&!1 bar v1.0.0 '"),
		Block(name: "ph",      placement: .left,  command: "echo ' by Panini House'"),
		Block(name: "memory",  placement: .right, command: "echo \"􀟱 Hi $USER, welcome to bar! | \""),
		Block(name: "clock",   placement: .right, command: "echo \"􀐬 $(date '+%a %d, %H:%M:%S') \"", interval: 1),
	]
}

// MARK: Types reference

extension Config {
	/// The bar position on the screen.
	enum Position: Sendable {
		/// Anchor the bar at the top of the screen.
		case top

		/// Anchor the bar at the bottom of the screen.
		case bottom
	}

	/// A block defined in the configuration.
	///
	/// Represents one unit of the bar. Each block is a named command that
	/// produces output on an optional timer. See ``bar/Block`` for the
	/// runtime counterpart that manages execution and cell publishing.
	struct Block: Sendable {
		/// The block identifier used for manual updates.
		///
		/// Some blocks do not need to be updated on an defined
		/// interval. You might want instead to react to specific
		/// events or "manually" update them.
		/// In such cases, you can send a standard system
		/// notification that tells *bar* to trigger an update
		/// for the block identified by the name.
		///
		/// E.g: `notifyutil -p bar.touch.<name>`
		///
		/// Be aware that nothing stops you from having multiple
		/// blocks with the same name. In such case, triggering
		/// a notification will cause all blocks with that name
		/// to be re-evaluated.
		let name: String

		/// Whether the block anchors to the left or right side of the bar.
		let placement: Placement

		/// The shell command used for updating the content.
		///
		/// You can write an expression directly in the block
		/// definition or you can point to a proper executable
		/// script somewhere on the system.
		///
		/// The command process will inherit the environment
		/// of the process that executed `bar` in the first place.
		/// This means that running `bar` from your regular shell
		/// or from launchctl might result in different behaviours.
		/// Make sure to test both scenarios properly.
		let command: String

		/// The interval, in seconds, at which the command is executed.
		///
		/// If set to `nil`, the block will be evaluated just once
		/// at launch. You can of course trigger a manual update via
		/// a notification later on.
		let interval: Double?

		/// Define a block of the bar.
		///
		/// - Parameters:
		///   - name: The block identifier used for manual updates.
		///   - placement: Left or right side of the bar.
		///   - command: The shell command used for updating the content.
		///   - interval: The interval, in seconds, at which the command is executed.
		///
		init(name: String, placement: Placement, command: String, interval: Double? = nil) {
			self.name = name
			self.placement = placement
			self.command = command
			self.interval = interval
		}

		/// Where the block is anchored inside the bar.
		enum Placement: Sendable {
			/// Anchored to the left side of the bar.
			case left
			/// Anchored to the right side of the bar.
			case right
		}
	}
}
