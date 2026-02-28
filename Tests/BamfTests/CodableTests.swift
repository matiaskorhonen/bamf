import Foundation
import Testing

@testable import Bamf

@Suite struct CodableTests {
  @Test func encodable() throws {
    let url = Bundle.module.url(forResource: "dji_small", withExtension: "mp4")!
    let bamf = try Bamf(url)

    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    encoder.dateEncodingStrategy = .iso8601

    let data = try encoder.encode(bamf)
    let json = String(data: data, encoding: .utf8)!

    #expect(json.count > 0)
  }
}
