import Foundation

@MainActor
final class Block: ObservableObject, Identifiable {
	let id = UUID()

	let name: String
	let placement: Config.Block.Placement
	let command: String
	let interval: Double?

	@Published var cells: [String] = []

	private var tick: Task<Void, Never>?

	init(name: String, placement: Config.Block.Placement, command: String, interval: Double? = nil) {
		self.name = name
		self.placement = placement
		self.command = command
		self.interval = interval
	}

	/// Initial paint + interval timer.
	func start() {
		runScript()
		startTick()
	}

	/// Re-run the command and update the cells on the main actor.
	func runScript() {
		let command = self.command
		Task.detached(priority: .utility) { [weak self] in
			let cells = Runner.run(command)
			await self?.apply(cells)
		}
	}

	/// Stop the interval timer.
	func stop() {
		tick?.cancel()
	}

	@MainActor
	private func apply(_ cells: [String]) {
		self.cells = cells
	}

	private func startTick() {
		guard let interval, interval > 0 else { return }
		tick = Task { [weak self] in
			while !Task.isCancelled {
				try? await Task.sleep(for: .seconds(interval))
				if Task.isCancelled { break }
				self?.runScript()
			}
		}
	}
}

extension Config.Block {
	@MainActor
	var resolved: phbar.Block {
		.init(name: name, placement: placement, command: command, interval: interval)
	}
}
