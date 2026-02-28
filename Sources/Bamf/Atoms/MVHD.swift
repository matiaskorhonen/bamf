import Foundation

extension Atom {
  // https://xhelmboyx.tripod.com/formats/mp4-layout.txt
  public class MVHD: Atom {
    /// If version is 1 then date and duration values are 8 bytes in length
    public var version: UInt8 {
      return UInt8(data[data.startIndex + 0])
    }
    /// Future movie header flags
    public var flags: [UInt8] {
      [
        UInt8(data[data.startIndex + 1]),
        UInt8(data[data.startIndex + 2]),
        UInt8(data[data.startIndex + 3]),
      ]
    }
    /// Movie creation datetime
    public var creationTime: Date {
      if version == 1 {
        let time: UInt64 = data[(data.startIndex + 4)..<(data.startIndex + 12)].asInteger()
        return Date(timeIntervalSince1904: TimeInterval(time))
      }
      return data[(data.startIndex + 4)..<(data.startIndex + 8)].asDate()
    }
    /// Movie modification datetime
    public var modificationTime: Date {
      if version == 1 {
        let time: UInt64 = data[(data.startIndex + 12)..<(data.startIndex + 20)].asInteger()
        return Date(timeIntervalSince1904: TimeInterval(time))
      }
      return data[(data.startIndex + 8)..<(data.startIndex + 12)].asDate()
    }
    /// A time value that indicates the time scale for this movie—that is, the
    /// number of time units that pass per second in its time coordinate system
    public var timeScale: UInt32 {
      let offset = version == 1 ? 20 : 12
      return data[(data.startIndex + offset)..<(data.startIndex + offset + 4)].asInteger()
    }
    /// A time value that indicates the duration of the movie in time scale
    /// units, derived from the movie’s tracks, corresponding to the duration
    /// of the longest track in the movie
    public var duration: UInt64 {
      if version == 1 {
        return data[(data.startIndex + 24)..<(data.startIndex + 32)].asInteger()
      }
      let d: UInt32 = data[(data.startIndex + 16)..<(data.startIndex + 20)].asInteger()
      return UInt64(d)
    }
    /// The rate at which to play this movie (a value of 1.0 indicates normal rate)
    public var preferredRate: Decimal {
      let offset = version == 1 ? 32 : 20
      return data[(data.startIndex + offset)..<(data.startIndex + offset + 4)].asFixedPoint(2, 2)
    }
    /// How loud to play this movie’s sound (a value of 1.0 indicates full volume)
    public var preferredVolume: Decimal {
      let offset = version == 1 ? 36 : 24
      return data[(data.startIndex + offset)..<(data.startIndex + offset + 2)].asFixedPoint(1, 1)
    }
    /// The number of the Next Track ID
    public var nextTrackID: UInt32 {
      let offset = version == 1 ? 108 : 96
      guard data.count >= offset + 4 else { return 0 }
      return data[(data.startIndex + offset)..<(data.startIndex + offset + 4)].asInteger()
    }

    override public var debugDescription: String {
      return """
        Atom(
          type=\(type),
          children=\(children.count)
          version=\(version)
          flags=\(flags)
          creationTime=\(creationTime)
          modificationTime=\(modificationTime)
          timeScale=\(timeScale)
          duration=\(duration)
          preferredRate=\(preferredRate)
          preferredVolume=\(preferredVolume)
          nextTrackID=\(nextTrackID)
        )
        """
    }

    init(data: Data) {
      super.init(data: data, type: "mvhd")
    }

    private enum CodingKeys: String, CodingKey {
      case type
      case version
      case flags
      case creationTime
      case modificationTime
      case timeScale
      case duration
      case preferredRate
      case preferredVolume
      case nextTrackID
    }

    override public func encode(to encoder: Encoder) throws {
      try super.encode(to: encoder)
      var container = encoder.container(keyedBy: CodingKeys.self)

      try container.encode(type, forKey: .type)
      try container.encode(version, forKey: .version)
      try container.encode(flags, forKey: .flags)
      try container.encode(creationTime, forKey: .creationTime)
      try container.encode(modificationTime, forKey: .modificationTime)
      try container.encode(timeScale, forKey: .timeScale)
      try container.encode(duration, forKey: .duration)
      try container.encode(preferredRate, forKey: .preferredRate)
      try container.encode(preferredVolume, forKey: .preferredVolume)
      try container.encode(nextTrackID, forKey: .nextTrackID)
    }
  }
}
