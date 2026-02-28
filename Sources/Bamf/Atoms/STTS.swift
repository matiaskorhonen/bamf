import Foundation

extension Atom {
  /// (Decoding) Time-to-Sample Box (ISO 14496-12 §8.6.1.2)
  public class STTS: Atom {
    /// A single entry in the time-to-sample table
    public struct Entry {
      /// Number of consecutive samples with the same delta
      public let sampleCount: UInt32
      /// The delta of these samples in the media time scale
      public let sampleDelta: UInt32
    }

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
    /// Number of entries in the time-to-sample table
    public var entryCount: UInt32 {
      return data[(data.startIndex + 4)..<(data.startIndex + 8)].asInteger()
    }
    /// The list of time-to-sample table entries
    public var entries: [Entry] {
      var result: [Entry] = []
      let count = Int(entryCount)
      result.reserveCapacity(count)
      var offset = data.startIndex + 8
      for _ in 0..<count {
        guard offset + 8 <= data.endIndex else { break }
        let sampleCount: UInt32 = data[offset..<(offset + 4)].asInteger()
        let sampleDelta: UInt32 = data[(offset + 4)..<(offset + 8)].asInteger()
        result.append(Entry(sampleCount: sampleCount, sampleDelta: sampleDelta))
        offset += 8
      }
      return result
    }

    override public var debugDescription: String {
      return "Atom(type=\(type), entryCount=\(entryCount))"
    }

    public init(data: Data) {
      super.init(data: data, type: "stts")
    }

    private enum CodingKeys: String, CodingKey {
      case type
      case version
      case flags
      case entryCount
    }

    override public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(type, forKey: .type)
      try container.encode(version, forKey: .version)
      try container.encode(flags, forKey: .flags)
      try container.encode(entryCount, forKey: .entryCount)
    }
  }
}
