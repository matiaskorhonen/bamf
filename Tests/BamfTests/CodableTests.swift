import Foundation
import Testing

@testable import Bamf

@Suite struct CodableTests {
  @Test func encodable() {
    let url = Bundle.module.url(forResource: "DJI_0007", withExtension: "MP4")!
    let Bamf = Bamf(url)

    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    encoder.dateEncodingStrategy = .iso8601

    let data = try! encoder.encode(Bamf)
    let json = String(data: data, encoding: .utf8)!

    #expect(json.count > 0)
  }
}
