import Foundation

/// Runs a shell command and returns its stdout as separate lines.
///
/// Blocking — always call from a background context (e.g. `Task.detached`).
enum Runner {
	/// Run a command and returns stdout as an array of separated lines.
	/// - Parameters:
	///   - command: The command to run.
	///   - env: An optional dictionary of strings to merge into
	///          the process environment.
	///
	/// - Returns: An array of the text lines printed to stdout.
	static func run(_ command: String, env: [String: String] = [:]) -> [String] {
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

		let data = stdout.fileHandleForReading.readDataToEndOfFile()
		let errData = stderr.fileHandleForReading.readDataToEndOfFile()
		process.waitUntilExit()

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
