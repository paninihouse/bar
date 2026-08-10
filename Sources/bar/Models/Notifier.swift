import Foundation

/// Retains the handler for the lifetime of the registration.
///
/// The raw pointer returned by ``Notifier/register(_:handler:)``
/// is a retained reference to this box; it is released when
/// the registration is cancelled.
private final class NotifyBox {
	let handler: @Sendable () -> Void
	init(_ handler: @escaping @Sendable () -> Void) { self.handler = handler }
}

/// Delivers refresh triggers via Darwin notifications.
///
/// Wraps CoreFoundation notifications — the macOS-native,
/// signal-like way to trigger behaviour from the shell with
/// no client binary, using `notifyutil`:
///
/// ```
/// notifyutil -p bar.touch.<block-name>
/// ```
///
/// > Note: `notify.h` isn't part of Swift's Darwin module,
/// > so we go through `CFNotificationCenter`, which talks
/// > to the same subsystem.
/// >
/// > The callback fires on an arbitrary thread; handlers
/// > must hop to the main actor themselves (see ``AppDelegate``).
enum Notifier {
	/// Register `handler` to fire whenever the notification is posted.
	///
	/// - Parameters:
	///   - name: The notification name.
	///   - handler: Closure to invoke when the notification fires.
	///
	/// The returned token is a retained pointer used to keep the handler
	/// alive and to cancel the registration later. The handler runs on an
	/// arbitrary thread, so hop to the main actor inside it if you touch
	/// UI or published state.
	@discardableResult
	static func register(
		_ name: String,
		handler: @escaping @Sendable () -> Void
	) -> UnsafeMutableRawPointer {
		let ctx = Unmanaged.passRetained(NotifyBox(handler)).toOpaque()

		CFNotificationCenterAddObserver(
			CFNotificationCenterGetDarwinNotifyCenter(),
			ctx,
			{ _, observer, _, _, _ in
				guard let observer else { return }
				let box = Unmanaged<NotifyBox>.fromOpaque(observer).takeUnretainedValue()
				box.handler()
			},
			name as CFString,
			nil,
			.deliverImmediately
		)

		return ctx
	}

	/// Remove and release a registration.
	///
	/// Pass the token returned by ``Notifier/register(_:handler:)``.
	/// Optional: process exit clears all pending registrations anyway.
	static func cancel(_ token: UnsafeMutableRawPointer) {
		let center = CFNotificationCenterGetDarwinNotifyCenter()
		CFNotificationCenterRemoveEveryObserver(center, token)
		Unmanaged<NotifyBox>.fromOpaque(token).release()
	}
}
