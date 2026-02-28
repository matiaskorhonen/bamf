import Foundation

extension Atom {
  /// Sample Size Box (ISO 14496-12 §8.7.3.2)
  public class STSZ: Atom {
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
    /// If non-zero, all samples have this size and no per-sample table is present
    public var sampleSize: UInt32 {
      return data[(data.startIndex + 4)..<(data.startIndex + 8)].asInteger()
    }
    /// Number of samples in the track
    public var sampleCount: UInt32 {
      return data[(data.startIndex + 8)..<(data.startIndex + 12)].asInteger()
    }
    /// Per-sample sizes; only populated when sampleSize is 0
    public var entrySizes: [UInt32] {
      guard sampleSize == 0 else { return [] }
      var result: [UInt32] = []
      let count = Int(sampleCount)
      result.reserveCapacity(count)
      var offset = data.startIndex + 12
      for _ in 0..<count {
        guard offset + 4 <= data.endIndex else { break }
        let size: UInt32 = data[offset..<(offset + 4)].asInteger()
        result.append(size)
        offset += 4
      }
      return result
    }

    override public var debugDescription: String {
      return "Atom(type=\(type), sampleSize=\(sampleSize), sampleCount=\(sampleCount))"
    }

    public init(data: Data) {
      super.init(data: data, type: "stsz")
    }

    private enum CodingKeys: String, CodingKey {
      case type
      case version
      case flags
      case sampleSize
      case sampleCount
    }

    override public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(type, forKey: .type)
      try container.encode(version, forKey: .version)
      try container.encode(flags, forKey: .flags)
      try container.encode(sampleSize, forKey: .sampleSize)
      try container.encode(sampleCount, forKey: .sampleCount)
    }
  }
}
