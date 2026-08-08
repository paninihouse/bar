import AppKit

// Entry point. Top-level code runs on the main actor.
let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.setActivationPolicy(.accessory) // no Dock icon, no menu
app.run()
