import SwiftUI

struct BlockView: View {
	@ObservedObject var block: Block

	var body: some View {
		HStack(spacing: 0) {
			ForEach(block.cells) { cell in
				CellView(cell: cell)
			}
		}
	}
}
