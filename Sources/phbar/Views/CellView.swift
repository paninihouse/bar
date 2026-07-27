import SwiftUI

struct CellView: View {
	var text: String

	var body: some View {
		VStack {
			Text(text)
		}
		.frame(height: Config.height)
		.background(Color.cyan)
	}
}
