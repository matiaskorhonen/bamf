import Foundation

extension Data {
  func asDate() -> Date {
    let time: UInt32 = self.asInteger()
    return Date(timeIntervalSince1904: TimeInterval(time))
  }
}
