import Foundation
import Testing

@Suite struct CLIIntegrationTests {
  // Walk up the directory tree from the test runner to find the bamf-cli binary,
  // handling both Linux (runner is the binary itself) and macOS (runner is inside
  // an .xctest bundle several levels deep).
  private func cliBinaryURL() throws -> URL {
    var url = URL(fileURLWithPath: ProcessInfo.processInfo.arguments[0])
    for _ in 0..<5 {
      url = url.deletingLastPathComponent()
      let candidate = url.appendingPathComponent("bamf-cli")
      if FileManager.default.fileExists(atPath: candidate.path) {
        return candidate
      }
    }
    throw CLITestError.binaryNotFound
  }

  private var testMP4URL: URL {
    URL(fileURLWithPath: #filePath)
      .deletingLastPathComponent()  // BamfCLITests/
      .deletingLastPathComponent()  // Tests/
      .appendingPathComponent("BamfTests/Resources/DJI_0007.MP4")
  }

  @discardableResult
  private func runCLI(args: [String]) throws -> (output: String, exitCode: Int32) {
    let process = Process()
    process.executableURL = try cliBinaryURL()
    process.arguments = args

    let outputPipe = Pipe()
    let errorPipe = Pipe()
    process.standardOutput = outputPipe
    process.standardError = errorPipe

    try process.run()
    process.waitUntilExit()

    let output = String(
      data: outputPipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8) ?? ""
    return (output: output, exitCode: process.terminationStatus)
  }

  @Test func helpShowsNoColorFlag() throws {
    let result = try runCLI(args: ["--help"])
    #expect(result.output.contains("--no-color"))
  }

  @Test func textOutputContainsAtomTypes() throws {
    let result = try runCLI(args: ["--no-color", testMP4URL.path])
    #expect(result.exitCode == 0)
    #expect(result.output.contains("[ftyp]") || result.output.contains("[FTYP]"))
  }

  @Test func noColorFlagProducesNoANSICodes() throws {
    let result = try runCLI(args: ["--no-color", testMP4URL.path])
    #expect(result.exitCode == 0)
    #expect(!result.output.contains("\u{001B}["))
  }

  @Test func jsonFormatOutputIsValidJSON() throws {
    let result = try runCLI(args: ["--format", "json", testMP4URL.path])
    #expect(result.exitCode == 0)
    let parsed = try? JSONSerialization.jsonObject(with: Data(result.output.utf8))
    #expect(parsed != nil)
  }
}

private enum CLITestError: Error {
  case binaryNotFound
}
