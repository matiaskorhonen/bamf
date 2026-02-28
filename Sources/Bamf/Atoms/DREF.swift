import Foundation

extension Atom {
  /// Data Reference Box (ISO 14496-12 §8.7.2)
  public class DREF: Atom {
    /// The version of this full box (should be 0)
    public var version: UInt8 {
      return UInt8(data[data.startIndex])
    }
    /// The flags field of this full box
    public var flags: [UInt8] {
      [
        UInt8(data[data.startIndex + 1]),
        UInt8(data[data.startIndex + 2]),
        UInt8(data[data.startIndex + 3]),
      ]
    }
    /// Number of data entries
    public var entryCount: UInt32 {
      return data[(data.startIndex + 4)..<(data.startIndex + 8)].asInteger()
    }

    override public var debugDescription: String {
      return """
        Atom(
          type=\(type),
          version=\(version)
          flags=\(flags)
          entryCount=\(entryCount)
          children=\(children.count)
        )
        """
    }

    public init(data: Data) {
      super.init(data: data, type: "dref")
      // Entries start after version(1) + flags(3) + entry_count(4) = 8 bytes
      let entriesStart = data.startIndex + 8
      if entriesStart < data.endIndex {
        self.children = (try? Bamf.parse(data[entriesStart..<data.endIndex])) ?? []
      }
    }

    private enum CodingKeys: String, CodingKey {
      case type
      case version
      case flags
      case entryCount
      case children
    }

    override public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(type, forKey: .type)
      try container.encode(version, forKey: .version)
      try container.encode(flags, forKey: .flags)
      try container.encode(entryCount, forKey: .entryCount)
      try container.encode(children, forKey: .children)
    }
  }
}
