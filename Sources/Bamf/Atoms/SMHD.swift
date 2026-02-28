import Foundation

extension Atom {
  /// Sound Media Header Box (ISO 14496-12 §12.2.2)
  public class SMHD: Atom {
    public var version: UInt8 {
      return UInt8(data[data.startIndex])
    }
    public var flags: [UInt8] {
      [
        UInt8(data[data.startIndex + 1]),
        UInt8(data[data.startIndex + 2]),
        UInt8(data[data.startIndex + 3]),
      ]
    }
    /// A value of 0.0 indicates centre, negative is to left, positive is to right (8.8 fixed point)
    public var balance: Decimal {
      return data[(data.startIndex + 4)..<(data.startIndex + 6)].asFixedPoint(1, 1)
    }

    override public var debugDescription: String {
      return """
        Atom(
          type=\(type),
          version=\(version)
          flags=\(flags)
          balance=\(balance)
        )
        """
    }

    public init(data: Data) {
      super.init(data: data, type: "smhd")
    }

    private enum CodingKeys: String, CodingKey {
      case type
      case version
      case flags
      case balance
    }

    override public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(type, forKey: .type)
      try container.encode(version, forKey: .version)
      try container.encode(flags, forKey: .flags)
      try container.encode(balance, forKey: .balance)
    }
  }
}
