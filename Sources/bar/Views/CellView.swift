import SwiftUI

struct CellView: View {
	var cell: Cell

	var body: some View {
		Text(cell.rawValue)
			.frame(height: Config.height)
			.background(cell.background)
	}
}
