import Foundation

extension Atom {
  // https://xhelmboyx.tripod.com/formats/mp4-layout.txt
  class MVHD: Atom {
    var version: UInt8 {
      return UInt8(data[data.startIndex + 0])
    }
    var flags: [UInt8] {
      [
        UInt8(data[data.startIndex + 1]),
        UInt8(data[data.startIndex + 2]),
        UInt8(data[data.startIndex + 3]),
      ]
    }
    var creationTime: Date {
      return data[(data.startIndex + 4)..<(data.startIndex + 8)].asDate()
    }
    var modificationTime: Date {
      data[(data.startIndex + 8)..<(data.startIndex + 12)].asDate()
    }
    var timeScale: UInt32 {
      let bytes = data[(data.startIndex + 12)..<(data.startIndex + 16)]
      return bytes.asInteger()
    }
    var duration: UInt32 {
      return data[(data.startIndex + 16)..<(data.startIndex + 20)].asInteger()
    }
    var preferredRate: Decimal {
      return data[(data.startIndex + 20)..<(data.startIndex + 24)].asFixedPoint(2, 2)
    }
    var preferredVolume: Decimal {
      return data[(data.startIndex + 24)..<(data.startIndex + 26)].asFixedPoint(1, 1)
    }
    var nextTrackID: UInt32 {
      return 0
    }

    override var debugDescription: String {
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

    override func encode(to encoder: Encoder) throws {
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
