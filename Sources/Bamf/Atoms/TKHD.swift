import Foundation

extension Atom {
  /// Track Header Box (ISO 14496-12 §8.3.2)
  public class TKHD: Atom {
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
    /// Track creation datetime
    public var creationTime: Date {
      if version == 1 {
        let time: UInt64 = data[(data.startIndex + 4)..<(data.startIndex + 12)].asInteger()
        return Date(timeIntervalSince1904: TimeInterval(time))
      }
      return data[(data.startIndex + 4)..<(data.startIndex + 8)].asDate()
    }
    /// Track modification datetime
    public var modificationTime: Date {
      if version == 1 {
        let time: UInt64 = data[(data.startIndex + 12)..<(data.startIndex + 20)].asInteger()
        return Date(timeIntervalSince1904: TimeInterval(time))
      }
      return data[(data.startIndex + 8)..<(data.startIndex + 12)].asDate()
    }
    /// A unique integer that identifies the track
    public var trackID: UInt32 {
      let offset = version == 1 ? 20 : 12
      return data[(data.startIndex + offset)..<(data.startIndex + offset + 4)].asInteger()
    }
    /// Duration of this track in movie time scale units
    public var duration: UInt64 {
      if version == 1 {
        return data[(data.startIndex + 28)..<(data.startIndex + 36)].asInteger()
      }
      let d: UInt32 = data[(data.startIndex + 20)..<(data.startIndex + 24)].asInteger()
      return UInt64(d)
    }
    /// The front-to-back ordering of video tracks; tracks with lower layers are closer to the viewer
    public var layer: Int16 {
      let offset = version == 1 ? 44 : 32
      let raw: UInt16 = data[(data.startIndex + offset)..<(data.startIndex + offset + 2)].asInteger()
      return Int16(bitPattern: raw)
    }
    /// Identifies a collection of movie tracks that contain alternate data
    public var alternateGroup: Int16 {
      let offset = version == 1 ? 46 : 34
      let raw: UInt16 = data[(data.startIndex + offset)..<(data.startIndex + offset + 2)].asInteger()
      return Int16(bitPattern: raw)
    }
    /// The preferred volume of the track's audio (8.8 fixed point)
    public var volume: Decimal {
      let offset = version == 1 ? 48 : 36
      return data[(data.startIndex + offset)..<(data.startIndex + offset + 2)].asFixedPoint(1, 1)
    }
    /// The visual width of this track (16.16 fixed point)
    public var width: Decimal {
      let offset = version == 1 ? 88 : 76
      return data[(data.startIndex + offset)..<(data.startIndex + offset + 4)].asFixedPoint(2, 2)
    }
    /// The visual height of this track (16.16 fixed point)
    public var height: Decimal {
      let offset = version == 1 ? 92 : 80
      return data[(data.startIndex + offset)..<(data.startIndex + offset + 4)].asFixedPoint(2, 2)
    }

    override public var debugDescription: String {
      return """
        Atom(
          type=\(type),
          version=\(version)
          flags=\(flags)
          creationTime=\(creationTime)
          modificationTime=\(modificationTime)
          trackID=\(trackID)
          duration=\(duration)
          layer=\(layer)
          alternateGroup=\(alternateGroup)
          volume=\(volume)
          width=\(width)
          height=\(height)
        )
        """
    }

    public init(data: Data) {
      super.init(data: data, type: "tkhd")
    }

    private enum CodingKeys: String, CodingKey {
      case type
      case version
      case flags
      case creationTime
      case modificationTime
      case trackID
      case duration
      case layer
      case alternateGroup
      case volume
      case width
      case height
    }

    override public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(type, forKey: .type)
      try container.encode(version, forKey: .version)
      try container.encode(flags, forKey: .flags)
      try container.encode(creationTime, forKey: .creationTime)
      try container.encode(modificationTime, forKey: .modificationTime)
      try container.encode(trackID, forKey: .trackID)
      try container.encode(duration, forKey: .duration)
      try container.encode(layer, forKey: .layer)
      try container.encode(alternateGroup, forKey: .alternateGroup)
      try container.encode(volume, forKey: .volume)
      try container.encode(width, forKey: .width)
      try container.encode(height, forKey: .height)
    }
  }
}
