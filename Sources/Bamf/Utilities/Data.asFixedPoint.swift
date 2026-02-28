import Foundation

extension Data {
  /// Interprets the receiver as a fixed-point number with the given integer and fraction byte widths.
  ///
  /// - Parameters:
  ///   - integerWidth: The number of bytes used for the integer part.
  ///   - fractionWidth: The number of bytes used for the fractional part.
  /// - Returns: A `Decimal` representing the fixed-point value.
  func asFixedPoint(_ integerWidth: Int, _ fractionWidth: Int) -> Decimal {
    let integer: Int = self[(self.startIndex)..<(self.startIndex + integerWidth)].asInteger()
    let fraction: Int = self[
      (self.startIndex + integerWidth)..<(self.startIndex + integerWidth + fractionWidth)
    ].asInteger()

    var decimal = Decimal(integer)

    let max = pow(2, fractionWidth * UInt8.bitWidth)
    if decimal > (max / 2) {
      decimal -= max
    }

    decimal += (1 / max) * Decimal(fraction)

    return decimal
  }
}
