// The Swift Programming Language
// https://docs.swift.org/swift-book
//
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser
import Bamf
import Foundation

@main
struct BamfCLI: ParsableCommand {
  static let configuration = CommandConfiguration(
    abstract: "BAMF CLI",
    discussion: """
        Output parsed data from ISOBMFF files as parsed by Bamf!

        Mostly for debugging and testing purposes.
      """
  )

  @Argument(help: "source MP4 file(s)", transform: URL.init(fileURLWithPath:))
  var source: [URL] = []

  mutating func run() {
    for url in source {
      let bamf = Bamf(url)

      let encoder = JSONEncoder()
      encoder.outputFormatting = .prettyPrinted
      encoder.dateEncodingStrategy = .iso8601

      let data = try! encoder.encode(bamf)
      let json = String(data: data, encoding: .utf8)!

      print(json)
    }
  }
}
