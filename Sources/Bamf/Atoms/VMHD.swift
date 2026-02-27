import Foundation

extension Atom {
  /// Video Media Header Box (ISO 14496-12 §12.1.2)
  public class VMHD: Atom {
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
    /// Composition mode for this video track
    public var graphicsMode: UInt16 {
      return data[(data.startIndex + 4)..<(data.startIndex + 6)].asInteger()
    }
    /// Colour values for the graphics mode
    public var opcolor: [UInt16] {
      return [
        data[(data.startIndex + 6)..<(data.startIndex + 8)].asInteger(),
        data[(data.startIndex + 8)..<(data.startIndex + 10)].asInteger(),
        data[(data.startIndex + 10)..<(data.startIndex + 12)].asInteger(),
      ]
    }

    override public var debugDescription: String {
      return """
        Atom(
          type=\(type),
          version=\(version)
          flags=\(flags)
          graphicsMode=\(graphicsMode)
          opcolor=\(opcolor)
        )
        """
    }

    public init(data: Data) {
      super.init(data: data, type: "vmhd")
    }

    private enum CodingKeys: String, CodingKey {
      case type
      case version
      case flags
      case graphicsMode
      case opcolor
    }

    override public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(type, forKey: .type)
      try container.encode(version, forKey: .version)
      try container.encode(flags, forKey: .flags)
      try container.encode(graphicsMode, forKey: .graphicsMode)
      try container.encode(opcolor, forKey: .opcolor)
    }
  }
}
