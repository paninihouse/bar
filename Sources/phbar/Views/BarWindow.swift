import AppKit

// A non-activating panel: clicking it (e.g. a workspace cell) runs the action
// without stealing focus from the app you're working in.
final class BarWindow: NSPanel {
	init(contentRect: NSRect) {
		super.init(
			contentRect: contentRect,
			styleMask: [.nonactivatingPanel],
			backing: .buffered,
			defer: false
		)

		isFloatingPanel = true
		isOpaque = false
		backgroundColor = .clear
		hasShadow = false
		hidesOnDeactivate = false
		isReleasedWhenClosed = false
		isMovable = false
		becomesKeyOnlyIfNeeded = true
		level = .floating
		collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary]
		animationBehavior = .none
	}

	override var canBecomeKey: Bool { true }
	override var canBecomeMain: Bool { false }
}
