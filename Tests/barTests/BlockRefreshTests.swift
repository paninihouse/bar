import Combine
import Testing
@testable import bar

@Test @MainActor func unchangedOutputDoesNotPublish() {
	let block = Block(name: "test", placement: .left, command: "")
	var publications = 0
	let subscription = block.$cells.dropFirst().sink { _ in publications += 1 }
	defer { subscription.cancel() }

	block.apply(["same", "same"])
	block.apply(["same", "same"])
	#expect(publications == 1)
	#expect(block.cells.map(\.rawValue) == ["same", "same"])

	// A highlight-only change must still publish, even with identical text.
	block.apply(["&!1 same", "same"])
	#expect(publications == 2)
	#expect(block.cells[0].id == " same:1")
	block.apply([])
	block.apply([])
	#expect(publications == 3)
	#expect(block.cells.isEmpty)
}

@Test func runnerPreservesOutputAcrossPoolDrain() {
	#expect(Runner.run("printf 'first\\n\\nlast\\n'") == ["first", "", "last"])
	#expect(Runner.run("exit 1") == ["ERROR"])
}
