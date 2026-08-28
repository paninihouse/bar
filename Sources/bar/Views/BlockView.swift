import SwiftUI

struct BlockView: View {
	@ObservedObject var block: Block

	@State private var hoveredCell: Cell?
	@State private var eventsMonitor: Any?

	var body: some View {
		HStack(spacing: 0) {
			ForEach(block.cells) { cell in
				CellView(cell: cell)
					.onHover { hovering in
						if hovering {
							hoveredCell = cell
						} else if hoveredCell?.id == cell.id {
							hoveredCell = nil
						}
					}
			}
		}
		.onAppear {
			let monitor = NSEvent.addLocalMonitorForEvents(matching: [
				.leftMouseDown,
				.rightMouseDown,
				.otherMouseDown,
				.scrollWheel,
			]) { [weak block] event in
				guard let block else { return event }
				return self.handle(event: event, block: block)
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

	/// Processes an event when a cell is hovered, re-running the script
	/// with the appropriate environment variable and the hovered cell's
	/// content.
	///
	/// - Returns: The original event so the system continues normal delivery.
	private func handle(event: NSEvent, block: Block) -> NSEvent {
		guard let cell = hoveredCell else { return event }

		switch event.type {
		case .leftMouseDown, .rightMouseDown, .otherMouseDown:
			block.runScript(env: ["BUTTON": String(event.buttonNumber), "CELL": cell.rawValue])
		case .scrollWheel:
			if event.scrollingDeltaY > 0 {
				block.runScript(env: ["SCROLL": "UP", "CELL": cell.rawValue])
			} else if event.scrollingDeltaY < 0 {
				block.runScript(env: ["SCROLL": "DOWN", "CELL": cell.rawValue])
			} else if event.scrollingDeltaX > 0 {
				block.runScript(env: ["SCROLL": "RIGHT", "CELL": cell.rawValue])
			} else if event.scrollingDeltaX < 0 {
				block.runScript(env: ["SCROLL": "LEFT", "CELL": cell.rawValue])
			}
		default:
			break
		}

		return event
	}
}
