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

	override var canBecomeMain: Bool { false }
	override var canBecomeKey: Bool { true }
}
