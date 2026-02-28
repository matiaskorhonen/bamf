import Foundation

extension Atom {
  /// Media Header Box (ISO 14496-12 §8.4.2)
  public class MDHD: Atom {
    /// Version 0 uses 32-bit time/duration fields; version 1 uses 64-bit fields.
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
    /// Media creation datetime
    public var creationTime: Date {
      if version == 1 {
        let time: UInt64 = data[(data.startIndex + 4)..<(data.startIndex + 12)].asInteger()
        return Date(timeIntervalSince1904: TimeInterval(time))
      }
      return data[(data.startIndex + 4)..<(data.startIndex + 8)].asDate()
    }
    /// Media modification datetime
    public var modificationTime: Date {
      if version == 1 {
        let time: UInt64 = data[(data.startIndex + 12)..<(data.startIndex + 20)].asInteger()
        return Date(timeIntervalSince1904: TimeInterval(time))
      }
      return data[(data.startIndex + 8)..<(data.startIndex + 12)].asDate()
    }
    /// Number of time units that pass per second
    public var timeScale: UInt32 {
      let offset = version == 1 ? 20 : 12
      return data[(data.startIndex + offset)..<(data.startIndex + offset + 4)].asInteger()
    }
    /// Duration of the media in time scale units
    public var duration: UInt64 {
      if version == 1 {
        return data[(data.startIndex + 24)..<(data.startIndex + 32)].asInteger()
      }
      let d: UInt32 = data[(data.startIndex + 16)..<(data.startIndex + 20)].asInteger()
      return UInt64(d)
    }
    /// ISO 639-2/T language code (3-character string, 5 bits per character)
    public var language: String {
      let offset = version == 1 ? 32 : 20
      let packed: UInt16 = data[(data.startIndex + offset)..<(data.startIndex + offset + 2)].asInteger()
      let c1 = UInt8((packed >> 10) & 0x1F) + 0x60
      let c2 = UInt8((packed >> 5) & 0x1F) + 0x60
      let c3 = UInt8(packed & 0x1F) + 0x60
      return String(bytes: [c1, c2, c3], encoding: .ascii) ?? ""
    }

    override public var debugDescription: String {
      return """
        Atom(
          type=\(type),
          version=\(version)
          flags=\(flags)
          creationTime=\(creationTime)
          modificationTime=\(modificationTime)
          timeScale=\(timeScale)
          duration=\(duration)
          language=\(language)
        )
        """
    }

    public init(data: Data) {
      super.init(data: data, type: "mdhd")
    }

    private enum CodingKeys: String, CodingKey {
      case type
      case version
      case flags
      case creationTime
      case modificationTime
      case timeScale
      case duration
      case language
    }

    override public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(type, forKey: .type)
      try container.encode(version, forKey: .version)
      try container.encode(flags, forKey: .flags)
      try container.encode(creationTime, forKey: .creationTime)
      try container.encode(modificationTime, forKey: .modificationTime)
      try container.encode(timeScale, forKey: .timeScale)
      try container.encode(duration, forKey: .duration)
      try container.encode(language, forKey: .language)
    }
  }
}
