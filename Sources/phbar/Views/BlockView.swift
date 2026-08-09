import SwiftUI

struct BlockView: View {
	@ObservedObject var block: Block

	@State private var hovering = false

	var body: some View {
		HStack(spacing: 0) {
			ForEach(block.cells) { cell in
				CellView(cell: cell)
			}
		}
		.onHover { hovering = $0 }
		.onAppear {
			NSEvent.addLocalMonitorForEvents(matching: [
				.leftMouseDown,
				.rightMouseDown,
				.otherMouseDown,
				.scrollWheel,
			]) { event in
				handle(event: event)
			}
		}
	}

	private func handle(event: NSEvent) -> NSEvent {
		guard hovering else { return event }

		switch event.type {
		case .leftMouseDown, .rightMouseDown, .otherMouseDown:
			block.runScript(env: ["BUTTON": String(event.buttonNumber)])
			break
		case .scrollWheel:
			if event.scrollingDeltaY > 0 {
				block.runScript(env: ["SCROLL": "UP"])
				break
			}

			if event.scrollingDeltaY < 0 {
				block.runScript(env: ["SCROLL": "DOWN"])
				break
			}

			if event.scrollingDeltaX > 0 {
				block.runScript(env: ["SCROLL": "RIGHT"])
				break
			}

			if event.scrollingDeltaX < 0 {
				block.runScript(env: ["SCROLL": "LEFT"])
				break
			}
		default:
			break
		}

		return event
	}
}
