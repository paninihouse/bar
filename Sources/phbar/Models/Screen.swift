import AppKit

/// Helpers for multi-screen geometry.
///
/// Maps a bar configuration (position, height) into concrete
/// screen coordinates so the window can be placed correctly
/// on each display.
enum Screen {
	/// Frame of the bar within a screen, in global display coordinates.
	///
	/// - Parameters:
	///   - screen: The screen to calculate the bar frame for.
	///   - position: Whether the bar sits at the top or bottom
	///               of the screen.
	///   - height: The bar height in points (see ``Config/height``).
	///
	/// - Returns: An ``NSRect`` in screen coordinates. The bar spans
	///            the full width of the screen and is anchored at the top
	///            or bottom edge.
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
