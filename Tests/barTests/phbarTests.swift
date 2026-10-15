import Foundation
import Synchronization
import Testing
@testable import bar

/// Blocking Runner work stays off the cooperative executor. The outer deadline
/// also fails promptly if a regression prevents Runner from returning.
private func runCommand(_ command: String, env: [String: String] = [:]) throws -> (lines: [String], diagnostics: Data) {
    let url = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    FileManager.default.createFile(atPath: url.path, contents: nil)
    let output = try FileHandle(forWritingTo: url)
    defer { try? FileManager.default.removeItem(at: url) }
    let result = Mutex<[String]?>(nil)
    let finished = DispatchSemaphore(value: 0)
    DispatchQueue.global(qos: .utility).async {
        let lines = Runner.run(command, env: env, errorOutput: output)
        try? output.close()
        result.withLock { $0 = lines }
        finished.signal()
    }
    let completed = finished.wait(timeout: .now() + 5) == .success
    try #require(completed, "Runner exceeded the five-second outer deadline")
    return (try #require(result.withLock { $0 }), try Data(contentsOf: url))
}

@Test func drainsLargeStderrBeforeStdout() throws {
    let result = try runCommand("/usr/bin/head -c 1048576 /dev/zero >&2; printf ' ready \\n'")
    #expect(result.lines == [" ready "])
    #expect(result.diagnostics == Data(repeating: 0, count: 1048576))
}

@Test func drainsSimultaneousLargeStreams() throws {
    let result = try runCommand("/usr/bin/head -c 1048576 /dev/zero >&2 & /usr/bin/head -c 1048576 /dev/zero; wait")
    #expect(result.lines == [String(repeating: "\0", count: 1048576)])
    #expect(result.diagnostics == Data(repeating: 0, count: 1048576))
}

@Test func emptyCommandOutput() throws {
    let result = try runCommand(":")
    #expect(result.lines.isEmpty)
    #expect(result.diagnostics.isEmpty)
}

@Test func failedCommandForwardsDiagnostics() throws {
    let result = try runCommand("printf 'ignored'; printf 'failure\\n' >&2; exit 7")
    #expect(result.lines == ["ERROR"])
    #expect(result.diagnostics == Data("failure\n".utf8))
}

@Test func shellEnvironmentAndWhitespaceArePreserved() throws {
    let result = try runCommand("printf ' %s \\n\\nlast\\n' \"$BAR_RUNNER_TEST\"; test -n \"$PATH\"", env: ["BAR_RUNNER_TEST": "value"])
    #expect(result.lines == [" value ", "", "last"])
}
