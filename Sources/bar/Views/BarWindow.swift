import AppKit

final class BarWindow: NSPanel {
	init(contentRect: NSRect) {
		super.init(
			contentRect: contentRect,
			styleMask: [.nonactivatingPanel, .borderless],
			backing: .buffered,
			defer: false
		)

		animationBehavior = .none
		backgroundColor = .clear
		becomesKeyOnlyIfNeeded = true
		collectionBehavior = [
			.canJoinAllSpaces,
			.fullScreenNone,
			.stationary,
			.transient,
		]
		hasShadow = false
		hidesOnDeactivate = false
		isFloatingPanel = true
		isMovable = false
		isOpaque = false
		isReleasedWhenClosed = false
		level = .floating
	}

	/// By default AppKit clamps the window frame so it never overlaps the
	/// menu bar (or the notch on MacBook displays), pushing the bar below
	/// the notch. `bar` must sit flush with the top edge of the screen
	/// instead, so we opt out of the constraint and keep the frame as-is.
	override func constrainFrameRect(_ frameRect: NSRect, to screen: NSScreen?) -> NSRect {
		frameRect
	}

	override var canBecomeMain: Bool { false }
	override var canBecomeKey: Bool { true }
}
