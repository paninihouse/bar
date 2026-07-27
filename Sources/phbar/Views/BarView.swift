import SwiftUI

struct BarView: View {
	private let left: [Block]
	private let right: [Block]

	init(blocks: [Block]) {
		self.left = blocks.filter { $0.placement == .left }
		self.right = blocks.filter { $0.placement == .right }
	}

	var body: some View {
		HStack(spacing: 0) {
			ForEach(left) { block in
				BlockView(block: block)
			}

			Spacer()

			ForEach(right) { block in
				BlockView(block: block)
			}
		}
		.font(Config.font)
		.foregroundStyle(Config.foreground)
		.frame(maxWidth: .infinity, maxHeight: Config.height)
		.background(Config.background)
	}
}
