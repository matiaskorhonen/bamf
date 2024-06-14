import Foundation
import Testing

@testable import ISOBMFF

@Suite struct CodableTests {
  @Test func encodable() {
    let url = Bundle.module.url(forResource: "DJI_0007", withExtension: "MP4")!
    let isobmff = ISOBMFF(url)

    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    encoder.dateEncodingStrategy = .iso8601

    let data = try! encoder.encode(isobmff)
    let json = String(data: data, encoding: .utf8)!
    #expect(json.count > 0)
  }
}
