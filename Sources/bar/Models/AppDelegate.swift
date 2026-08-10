import AppKit
import SwiftUI

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
	private var windows: [BarWindow] = []
	private var blocks: [Block] = Config.blocks.map(\.resolved)
	private var tokens: [UnsafeMutableRawPointer] = []

	func applicationDidFinishLaunching(_ notification: Notification) {
		for screen in NSScreen.screens {
			let frame = Screen.barFrame(screen, position: Config.position, height: Config.height)
			let window = BarWindow(contentRect: frame)
			window.contentView = NSHostingView(rootView: BarView(blocks: blocks))
			window.orderFrontRegardless()
			windows.append(window)
		}

		// Register a listener to hide the bar
		tokens.append(
			Notifier.register("bar.hide") { [weak self] in
				self?.hide()
			}
		)

		// Register a listener to show the bar
		tokens.append(
			Notifier.register("bar.show") { [weak self] in
				self?.show()
			}
		)

		// Register one listener per unique name; a single post fans out to every
		// block with that name (see Notifier).
		for name in Set(blocks.map(\.name)) {
			let token = Notifier.register("bar.touch.\(name)") { [weak self] in
				self?.handleRefresh(name)
			}
			tokens.append(token)
		}

		// Start the block's auto refresh
		for block in blocks { block.start() }
	}

	func applicationWillTerminate(_ notification: Notification) {
		for block in blocks { block.stop() }
		for token in tokens { Notifier.cancel(token) }
	}

	/// Order out all bar windows
	nonisolated private func hide() {
		Task { @MainActor [weak self] in
			guard let self else { return }
			for window in self.windows {
				window.orderOut(nil)
			}
		}
	}

	/// Order front all bar windows
	nonisolated private func show() {
		Task { @MainActor [weak self] in
			guard let self else { return }
			for window in self.windows {
				window.orderFrontRegardless()
			}
		}
	}

	/// Called from a Darwin notification handler. Marked `nonisolated` because
	/// libnotify's delivery contract isn't statically visible to Swift, so we
	/// hop back to the main actor explicitly.
	nonisolated func handleRefresh(_ name: String) {
		Task { @MainActor [weak self] in
			guard let self else { return }
			for block in self.blocks where block.name == name {
				block.runScript()
			}
		}
	}
}
