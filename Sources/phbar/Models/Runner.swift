import Foundation

/// Runs a shell command and returns its stdout as separate lines.
///
/// Blocking — always call from a background context (e.g. `Task.detached`).
enum Runner {
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

		guard let _ = try? process.run() else {
			return ["(error)"]
		}

		let data = stdout.fileHandleForReading.readDataToEndOfFile()
		let errData = stderr.fileHandleForReading.readDataToEndOfFile()
		process.waitUntilExit()

		if process.terminationStatus != 0 {
			let reason = String(data: errData, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)
			FileHandle.standardError.write("phbar: `\(command)` failed: \(reason ?? "exit \(process.terminationStatus)")\n".data(using: .utf8)!)
		}

		return parse(String(data: data, encoding: .utf8) ?? "")
	}

	/// Split output into lines. A single trailing newline
	/// (from a final `\n`) is dropped; blank lines elsewhere
	/// are kept so a script can emit intentional gaps.
	static func parse(_ text: String) -> [String] {
		var lines = text.components(separatedBy: "\n")
		if lines.last == "" { lines.removeLast() }
		return lines
	}
}
