import Foundation

extension Data {
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
