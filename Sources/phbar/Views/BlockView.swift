import SwiftUI

struct BlockView: View {
	@ObservedObject var block: Block

	var body: some View {
		HStack(spacing: 0) {
			ForEach(block.cells.indices, id: \.self) { index in
				CellView(text: block.cells[index])
			}
		}
	}
}
