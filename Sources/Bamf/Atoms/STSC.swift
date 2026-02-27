import Foundation

extension Atom {
  /// Sample-to-Chunk Box (ISO 14496-12 §8.7.4)
  public class STSC: Atom {
    public struct Entry {
      /// The index of the first chunk in the run
      public let firstChunk: UInt32
      /// The number of samples in each chunk
      public let samplesPerChunk: UInt32
      /// The sample description for this run of chunks
      public let sampleDescriptionIndex: UInt32
    }

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
    public var entryCount: UInt32 {
      return data[(data.startIndex + 4)..<(data.startIndex + 8)].asInteger()
    }
    public var entries: [Entry] {
      var result: [Entry] = []
      let count = Int(entryCount)
      result.reserveCapacity(count)
      var offset = data.startIndex + 8
      for _ in 0..<count {
        guard offset + 12 <= data.endIndex else { break }
        let firstChunk: UInt32 = data[offset..<(offset + 4)].asInteger()
        let samplesPerChunk: UInt32 = data[(offset + 4)..<(offset + 8)].asInteger()
        let sampleDescriptionIndex: UInt32 = data[(offset + 8)..<(offset + 12)].asInteger()
        result.append(Entry(firstChunk: firstChunk, samplesPerChunk: samplesPerChunk, sampleDescriptionIndex: sampleDescriptionIndex))
        offset += 12
      }
      return result
    }

    override public var debugDescription: String {
      return "Atom(type=\(type), entryCount=\(entryCount))"
    }

    public init(data: Data) {
      super.init(data: data, type: "stsc")
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
