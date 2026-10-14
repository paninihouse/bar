import AppKit
import Testing
@testable import bar

@Test @MainActor func monitorLifetime() {
	let block = Block(name: "test", placement: .left, command: "")
	var interaction: BlockInteraction? = BlockInteraction()
	weak let owner = interaction
	interaction?.start(block: block)
	let first = interaction?.eventsMonitor as AnyObject?
	#expect(first != nil)
	interaction?.start(block: block)
	#expect(first === (interaction?.eventsMonitor as AnyObject?))
	interaction?.hoveredIndex = 0
	interaction?.stop()
	#expect(interaction?.eventsMonitor == nil)
	#expect(interaction?.hoveredIndex == nil)
	interaction?.stop()
	interaction?.start(block: block)
	#expect(interaction?.eventsMonitor != nil)
	interaction = nil
	#expect(owner == nil)
}

@Test @MainActor func monitorDoesNotOwnBlock() {
	let interaction = BlockInteraction()
	var block: Block? = Block(name: "test", placement: .left, command: "")
	weak let observedBlock = block
	interaction.start(block: block!)
	block = nil
	#expect(observedBlock == nil)
	interaction.stop()
}

@Test @MainActor func hoverResolvesCurrentContent() {
	let block = Block(name: "test", placement: .left, command: "")
	let interaction = BlockInteraction()
	block.cells = [Cell(rawValue: "old"), Cell(rawValue: "second")]
	interaction.hoveredIndex = 0
	#expect(interaction.hoveredCell(in: block)?.rawValue == "old")
	block.cells = [Cell(rawValue: "new"), Cell(rawValue: "new")]
	#expect(interaction.hoveredCell(in: block)?.rawValue == "new")
	interaction.hoveredIndex = 1
	block.cells = [Cell(rawValue: "remaining")]
	#expect(interaction.hoveredCell(in: block) == nil)
	interaction.stop()
	#expect(interaction.hoveredCell(in: block) == nil)
}
