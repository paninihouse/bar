import SwiftUI

enum Config {
	// Geometry
	static let height: CGFloat = 30
	static let position: Position = .top

	// Appearance
	static let font: Font = .custom("Comic Code", fixedSize: 14)
	static let foreground: Color = .hex("#aed3f3")
	static let background: Color = .hex("#010408").opacity(0.825)

	// Blocks
	static let blocks: [Block] = [
		Block(name: "app",   placement: .left,  command: "echo ' 􀙅 Safari '"),
		Block(name: "clock", placement: .right, command: "echo ' TODAY '"),
	]
}

// MARK: Support types

extension Config {
	enum Position: Sendable {
		/// Anchor the bar at the top of the screen.
		case top

		/// Anchor the bar at the bottom of the screen.
		case bottom
	}

	struct Block: Sendable {
		/// The block identifier used for manual updates.
		///
		/// Some blocks do not need to be updated on an defined
		/// interval. You might want instead to react to specific
		/// events or "manually" update them.
		/// In such cases, you can send a standard system
		/// notification that tells phbar to trigger an update
		/// for the block identified by the name.
		///
		/// E.g: `notifyutil -p house.panini.phbar.touch.<name>`
		///
		/// Be aware that nothing stops you from having multiple
		/// blocks with the same name. In such case, triggering
		/// a notification will cause all blocks with that name
		/// to be re-evaluated.
		let name: String

		let placement: Placement

		/// The shell command used for updating the content.
		///
		/// You can write an expression directly in the block
		/// definition or you can point to a proper executable
		/// script somewhere on the system.
		///
		/// The command process will inherit the environment
		/// of the process that executed phbar in the first place.
		/// This means that running phbar from your regular shell
		/// or from launchctl might result in different behaviours.
		/// Make sure to test both scenarios properly.
		let command: String

		/// The interval, in seconds, at which the command is executed.
		///
		/// If set to `nil`, the block will be evaluated just once
		/// at launch. You can of course trigger a manual update via
		/// a notification later on.
		let interval: Double?

		init(name: String, placement: Placement, command: String, interval: Double? = nil) {
			self.name = name
			self.placement = placement
			self.command = command
			self.interval = interval
		}

		enum Placement: Sendable {
			case left
			case center
			case right
		}
	}
}
