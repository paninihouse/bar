import AppKit

@MainActor
enum Screen {
	/// Frame of the bar within a screen, in global display coordinates.
	static func barFrame(_ screen: NSScreen, position: Config.Position, height: CGFloat) -> NSRect {
		switch position {
		case .top:
			return NSRect(
				x: screen.frame.minX,
				y: screen.frame.maxY - height,
				width: screen.frame.width,
				height: height
			)
		case .bottom:
			return NSRect(
				x: screen.frame.minX,
				y: screen.frame.minY,
				width: screen.frame.width,
				height: height
			)
		}
	}
}
