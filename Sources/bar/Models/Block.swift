import Foundation

/// A named, self-updating unit of the bar.
///
/// Each block runs a shell command on an optional timer,
/// splits its stdout into ``Cell`` values, and publishes
/// them for rendering. Blocks are identified by ``name``
/// so they can be refreshed on demand via Darwin
/// notifications (see ``Notifier``).
@MainActor
final class Block: ObservableObject, Identifiable {
	/// Stable identity for SwiftUI diffing.
	let id = UUID()

	/// Identifier used for manual updates via Darwin
	/// notifications.
	///
	/// Multiple blocks can share the same name.
	/// In such case, a single notification will refresh
	/// all of them.
	let name: String

	/// Whether the block is anchored to the left or right
	/// side of the bar.
	let placement: Config.Block.Placement

	/// The shell command to execute for producing the cells.
	///
	/// Can be an inline expression or a path to an executable
	/// script. Inherits the environment of the `bar` process.
	let command: String

	/// Refresh interval in seconds, or `nil` for a one-shot block.
	///
	/// A one-shot block can still be manually refreshed via
	/// a Darwin notification (see ``Notifier``).
	let interval: Double?

	/// The current cells produced by the last command execution.
	///
	/// SwiftUI observes this `@Published` property and re-renders
	/// the view tree automatically.
	@Published var cells: [Cell] = []

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
	func runScript(env: [String: String] = [:]) {
		let command = self.command

		var env = env
		env.updateValue(name, forKey: "BLOCK")

		Task.detached(priority: .utility) { [weak self] in
			let lines = Runner.run(command, env: env)
			await self?.apply(lines)
		}
	}

	/// Stop the interval timer.
	func stop() {
		tick?.cancel()
	}

	/// Replace the current cells with freshly parsed lines.
	///
	/// Each line becomes a ``Cell``. This is always called
	/// on the main actor so SwiftUI sees the update immediately.
	@MainActor
	private func apply(_ lines: [String]) {
		self.cells = lines.map { Cell(rawValue: $0) }
	}

	/// Start the interval timer that re-runs the command periodically.
	///
	/// Does nothing when ``interval`` is `nil` or ≤ 0.
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
	var resolved: bar.Block {
		.init(name: name, placement: placement, command: command, interval: interval)
	}
}
