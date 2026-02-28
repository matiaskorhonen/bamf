import Foundation

extension Data {
  /// Interprets the bytes of the receiver as a big-endian fixed-width integer.
  ///
  /// - Returns: The integer value represented by the bytes.
  func asInteger<T: FixedWidthInteger>() -> T {
    let bytes = [UInt8](self)

    let bits = (bytes.count * UInt8.bitWidth)
    guard T.bitWidth >= bits else {
      fatalError("Cannot convert \(bits) bits to \(T.bitWidth)-bit integer")
    }

    return bytes.reduce(0) { soFar, byte in
      return soFar << 8 | T(byte)
    }
  }
}
