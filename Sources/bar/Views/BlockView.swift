import SwiftUI

struct BlockView: View {
	@ObservedObject var block: Block

	@State private var hovering = false
	@State private var eventsMonitor: Any?

	var body: some View {
		HStack(spacing: 0) {
			ForEach(block.cells) { cell in
				CellView(cell: cell)
			}
		}
		.onHover { hovering = $0 }
		.onAppear {
			let monitor = NSEvent.addLocalMonitorForEvents(matching: [
				.leftMouseDown,
				.rightMouseDown,
				.otherMouseDown,
				.scrollWheel,
			]) { [weak block] event in
				guard let block else { return event }
				return handle(event: event, block: block)
			}
			self.eventsMonitor = monitor as Any
		}
		.onDisappear {
			if let eventsMonitor {
				NSEvent.removeMonitor(eventsMonitor)
				self.eventsMonitor = nil
			}
		}
	}

	/// Processes an event when the block is hovered, re-running the script
	/// with the appropriate environment variable.
	///
	/// - Returns: The original event so the system continues normal delivery.
	private func handle(event: NSEvent, block: Block) -> NSEvent {
		guard hovering else { return event }

		switch event.type {
		case .leftMouseDown, .rightMouseDown, .otherMouseDown:
			block.runScript(env: ["BUTTON": String(event.buttonNumber)])
		case .scrollWheel:
			if event.scrollingDeltaY > 0 {
				block.runScript(env: ["SCROLL": "UP"])
			} else if event.scrollingDeltaY < 0 {
				block.runScript(env: ["SCROLL": "DOWN"])
			} else if event.scrollingDeltaX > 0 {
				block.runScript(env: ["SCROLL": "RIGHT"])
			} else if event.scrollingDeltaX < 0 {
				block.runScript(env: ["SCROLL": "LEFT"])
			}
		default:
			break
		}

		return event
	}
}
