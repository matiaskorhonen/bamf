import Foundation

extension Data {
  /// Interprets the receiver as a 32-bit unsigned Mac epoch (seconds since 1904-01-01) and returns it as a `Date`.
  ///
  /// - Returns: A `Date` corresponding to the Mac timestamp stored in the receiver.
  func asDate() -> Date {
    let time: UInt32 = self.asInteger()
    return Date(timeIntervalSince1904: TimeInterval(time))
  }
}
