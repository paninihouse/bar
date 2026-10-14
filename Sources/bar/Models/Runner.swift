import Foundation

/// Runs a shell command and returns its stdout as separate lines.
///
/// Blocking — always call from a background context (e.g. `Task.detached`).
/// After 30 seconds, requests termination of the shell process. This is
/// not a hard execution limit: the shell can ignore termination, and child
/// processes can keep output pipes open. Pipe reads and waiting can still block.
enum Runner {
	/// Delay in seconds before requesting shell termination with SIGTERM.
	/// Does not forcibly kill the shell or terminate its descendants.
	private static let timeout: Double = 30

	/// Run a command and returns stdout as an array of separated lines.
	/// - Parameters:
	///   - command: The command to run.
	///   - env: An optional dictionary of strings to merge into
	///          the process environment.
	///
	/// - Returns: Parsed stdout on success; ["ERROR"] on launch failure or
	///   nonzero exit, or [""] if successful output cannot be decoded as UTF-8.
	///   Captured stderr is forwarded only after a nonzero exit.
	static func run(_ command: String, env: [String: String] = [:]) -> [String] {
		// Detached tasks do not run inside AppKit's main event-loop pool.
		// Drain temporary Foundation objects at the end of each command.
		autoreleasepool { execute(command, env: env) }
	}

	private static func execute(_ command: String, env: [String: String]) -> [String] {
		let process = Process()
		process.executableURL = URL(fileURLWithPath: "/bin/sh")
		process.arguments = ["-c", command]

		var environment = ProcessInfo.processInfo.environment
		environment.merge(env) { _, new in new }
		process.environment = environment

		let stdout = Pipe()
		let stderr = Pipe()
		process.standardOutput = stdout
		process.standardError = stderr

		guard (try? process.run()) != nil else {
			return ["ERROR"]
		}

		// Request shell termination after the timeout expires.
		// Cancel the timer after pipe reads and process waiting finish.
		let timer = DispatchSource.makeTimerSource()
		timer.schedule(deadline: .now() + timeout)
		timer.setEventHandler { [weak process] in
			process?.terminate()
		}
		timer.resume()

		let data = stdout.fileHandleForReading.readDataToEndOfFile()
		let errData = stderr.fileHandleForReading.readDataToEndOfFile()
		process.waitUntilExit()

		timer.cancel()

		guard process.terminationStatus == 0 else {
			write(errData, to: .standardError)
			return ["ERROR"]
		}

		guard let string = String(data: data, encoding: .utf8) else {
			return [""]
		}

		return parse(string)
	}

	/// Split output into lines. A single trailing newline
	/// (from a final `\n`) is dropped; blank lines elsewhere
	/// are kept so a script can emit intentional gaps.
	static func parse(_ text: String) -> [String] {
		var lines = text.components(separatedBy: "\n")
		if lines.last == "" { lines.removeLast() }
		return lines
	}

	/// Write data to the provided handle.
	/// - Parameters:
	///   - data: The data to write.
	///   - handle: The handle to which data should be written.
	static func write(_ data: Data, to handle: FileHandle) {
		handle.write(data)
	}

	/// Write string to the provided handle.
	/// - Parameters:
	///   - string: The string to write.
	///   - handle: The handle to which data should be written.
	static func write(_ string: String, to handle: FileHandle) {
		write(Data(string.utf8), to: handle)
	}
}
