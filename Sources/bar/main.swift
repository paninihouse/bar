import AppKit

// Entry point. Top-level code runs on the main actor.
private let app = NSApplication.shared
private let delegate = AppDelegate()
app.delegate = delegate
app.setActivationPolicy(.accessory) // no Dock icon, no menu
app.run()
