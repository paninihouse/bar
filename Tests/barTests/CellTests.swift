import SwiftUI
import Testing
@testable import bar

@Test(arguments: [
	"", "ordinary text", "text &!1 more", " &!1 text",
	"&!", "&!1", "&!12", "&!0", "&!999999999999999999999999999999",
	"&! text", "&!-1 text", "&!+1 text", "&!１ text", "&!١ text",
]) func literalCellText(_ input: String) {
	let cell = Cell(rawValue: input)
	#expect(cell.rawValue == input)
	#expect(cell.background == .clear)
	#expect(cell.id == "\(input):0")
}

@Test(arguments: ["0", "12", "999999999999999999999999999999"]) func invalidCellLevels(_ level: String) {
	let cell = Cell(rawValue: "&!\(level) text")
	#expect(cell.rawValue == " text")
	#expect(cell.background == .clear)
	#expect(cell.id == " text:0")
}

@Test func configuredCellHighlights() {
	for level in 1...Config.highlights.count {
		for body in ["hello", " hello", " ", "\t", "\n", "&!2 nested"] {
			let cell = Cell(rawValue: "&!\(level)\(body)")
			#expect(cell.rawValue == body)
			#expect(cell.background == Config.highlights[level - 1])
			#expect(cell.id == "\(body):\(level)")
		}
	}
	let cell = Cell(rawValue: "&!01 hello")
	#expect(cell.background == Config.highlights[0])
	#expect(cell.rawValue == " hello")
	let outOfRange = Cell(rawValue: "&!\(Config.highlights.count + 1) text")
	#expect(outOfRange.rawValue == " text")
	#expect(outOfRange.background == .clear)
}
