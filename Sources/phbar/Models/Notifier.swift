import Foundation

// Darwin notifications via CoreFoundation — the macOS-native, signal-like way
// to trigger a refresh from the shell with no client binary:
//
//     notifyutil -p <prefix><name>
//
// e.g.   notifyutil -p house.panini.phbar.touch.workspaces
//
// (notify.h isn't part of Swift's Darwin module, so we go through
// CFNotificationCenter, which talks to the same subsystem.)
//
// The callback fires on an arbitrary thread; handlers must hop to the main
// actor themselves (see AppDelegate.handleRefresh).

/// Retains the handler for the lifetime of the registration.
private final class NotifyBox {
	let handler: @Sendable () -> Void
	init(_ handler: @escaping @Sendable () -> Void) { self.handler = handler }
}

enum Notifier {
	static let prefix = "house.panini.phbar.touch."

	/// Register `handler` to fire whenever the notification is posted.
	@discardableResult
	static func register(_ name: String, handler: @escaping @Sendable () -> Void)
		-> UnsafeMutableRawPointer
	{
		let fullName = prefix + name
		let ctx = Unmanaged.passRetained(NotifyBox(handler)).toOpaque()

		CFNotificationCenterAddObserver(
			CFNotificationCenterGetDarwinNotifyCenter(),
			ctx,
			{ _, observer, _, _, _ in
				guard let observer else { return }
				let box = Unmanaged<NotifyBox>.fromOpaque(observer).takeUnretainedValue()
				box.handler()
			},
			fullName as CFString,
			nil,
			.deliverImmediately
		)

		return ctx
	}

	/// Remove and release a registration. (Optional: process exit clears all.)
	static func cancel(_ token: UnsafeMutableRawPointer) {
		let center = CFNotificationCenterGetDarwinNotifyCenter()
		CFNotificationCenterRemoveEveryObserver(center, token)
		Unmanaged<NotifyBox>.fromOpaque(token).release()
	}
}
