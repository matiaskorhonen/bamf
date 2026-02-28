import Foundation

extension Data {
  /// A hexadecimal string representation of the bytes, with each byte separated by a space.
  var hex: String {
    self.map { String(format: "%02x", $0) }.joined(separator: " ")
  }
}
