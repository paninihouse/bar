import SwiftUI

struct BlockView: View {
	@ObservedObject var block: Block

	@State private var interaction = BlockInteraction()

	var body: some View {
		HStack(spacing: 0) {
			ForEach(block.cells.indices, id: \.self) { index in
				CellView(cell: block.cells[index])
					.onHover { hovering in
						if hovering {
							interaction.hoveredIndex = index
						} else if interaction.hoveredIndex == index {
							interaction.hoveredIndex = nil
						}
					}
			}
		}
		.onAppear { [weak block, weak interaction] in
			guard let block else { return }
			interaction?.start(block: block)
		}
		.onDisappear { [weak interaction] in
			interaction?.stop()
		}
		.onChange(of: block.cells.count) { _, count in
			if let index = interaction.hoveredIndex, index >= count {
				interaction.hoveredIndex = nil
			}
		}
	}
}

/// Per-view state: the application-owned monitor must not retain its owner
/// or the block. Disappearance removes it; destruction is a fallback when
/// a hosting view is discarded without a disappearance callback.
@MainActor
final class BlockInteraction {
	var hoveredIndex: Int?
	private(set) var eventsMonitor: Any?

	func start(block: Block) {
		guard eventsMonitor == nil else { return }
		eventsMonitor = NSEvent.addLocalMonitorForEvents(matching: [
			.leftMouseDown,
			.rightMouseDown,
			.otherMouseDown,
			.scrollWheel,
		]) { [weak block, weak self] event in
			guard let block, let self else { return event }
			return self.handle(event: event, block: block)
		}
	}

	func stop() {
		if let eventsMonitor {
			NSEvent.removeMonitor(eventsMonitor)
			self.eventsMonitor = nil
		}
		hoveredIndex = nil
	}

	isolated deinit {
		if let eventsMonitor { NSEvent.removeMonitor(eventsMonitor) }
	}

	func hoveredCell(in block: Block) -> Cell? {
		guard let index = hoveredIndex, block.cells.indices.contains(index) else { return nil }
		return block.cells[index]
	}

	/// Processes an event when a cell is hovered, re-running the script
	/// with the appropriate environment variable and the hovered cell's
	/// content.
	///
	/// - Returns: The original event so the system continues normal delivery.
	private func handle(event: NSEvent, block: Block) -> NSEvent {
		guard let cell = hoveredCell(in: block) else { return event }

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
