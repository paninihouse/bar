import SwiftUI
import Testing
@testable import bar

private func expectColor(_ color: Color, _ red: Double, _ green: Double, _ blue: Double, _ alpha: Double = 1) {
	let actual = color.resolve(in: EnvironmentValues())
	let expected = Color(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
		.resolve(in: EnvironmentValues())
	#expect(abs(actual.red - expected.red) < 0.00001)
	#expect(abs(actual.green - expected.green) < 0.00001)
	#expect(abs(actual.blue - expected.blue) < 0.00001)
	#expect(abs(actual.opacity - expected.opacity) < 0.00001)
}

@Test func validHexColors() {
	expectColor(.hex("#3aF"), 0x33 / 255.0, 0xAA / 255.0, 1)
	expectColor(.hex("3Af8"), 0x33 / 255.0, 0xAA / 255.0, 1, 0x88 / 255.0)
	expectColor(.hex("33aaff"), 0x33 / 255.0, 0xAA / 255.0, 1)
	expectColor(.hex(" \n#33AAff80\t"), 0x33 / 255.0, 0xAA / 255.0, 1, 0x80 / 255.0)
	expectColor(.hex("#0000"), 0, 0, 0, 0)
	expectColor(.hex("#ffffff00"), 1, 1, 1, 0)
	expectColor(.hex("#FFFFFFFF"), 1, 1, 1)
}

@Test(arguments: [
	"", " \n\t", "#", "12", "12345", "1234567", "123456789",
	"g12", "1g2", "12g", "g123", "1g23", "123g",
	"g12345", "12g345", "12345g", "g1234567", "123g4567", "1234567g",
	"+123", "-123", "0xFF", "# 123", "12 3", "##123", "１２３", "abc💙",
]) func malformedHexIsOpaqueBlack(_ input: String) {
	expectColor(.hex(input), 0, 0, 0)
}

@Test @MainActor func configuredColorsKeepTheirAppearance() {
	expectColor(Config.foreground, 0xAE / 255.0, 0xD3 / 255.0, 0xF3 / 255.0)
	expectColor(Config.background, 0x01 / 255.0, 0x04 / 255.0, 0x08 / 255.0, 0.825)
	expectColor(Config.highlights[0], 0x0F / 255.0, 0x30 / 255.0, 0x4A / 255.0)
	expectColor(Config.highlights[1], 0x1F / 255.0, 0x68 / 255.0, 0x9D / 255.0)
}
