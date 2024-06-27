import Foundation

extension Atom {
  class TKHD: Atom {
    /// If version is 1 then date and duration values are 8 bytes in length
    public var version: UInt8 {
      return UInt8(data[data.startIndex + 0])
    }
    /// Future track header flags
    public var flags: [UInt8] {
      [
        UInt8(data[data.startIndex + 1]),
        UInt8(data[data.startIndex + 2]),
        UInt8(data[data.startIndex + 3]),
      ]
    }
    /// Track creation datetime
    public var creationTime: Date {
      data[(data.startIndex + 4)..<(data.startIndex + 8)].asDate()
    }
    /// Track modification datetime
    public var modificationTime: Date {
      data[(data.startIndex + 8)..<(data.startIndex + 12)].asDate()
    }
    /// A unique integer that identifies the track
    public var trackID: UInt32 {
      return 0
    }
    public var reserved1: UInt32 {
      return 0
    }
    public var duration: UInt32 {
      return 0
    }
    public var reserved2: UInt32 {
      return 0
    }
    public var layer: UInt32 {
      return 0
    }
    public var alternateGroup: UInt32 {
      return 0
    }
    public var volume: Float {
      return 0
    }
    public var matrix: String {
      return ""
    }
    public var width: UInt32 {
      return 0
    }
    public var height: UInt32 {
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
          trackID=\(trackID)
          duration=\(duration)
          reserved1=\(reserved1)
          reserved2=\(reserved2)
          layer=\(layer)
          alternateGroup=\(alternateGroup)
          volume=\(volume)
          matrix=\(matrix)
          width=\(width)
          height=\(height)
        )
        """
    }

    init(data: Data) {
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
      case reserved1
      case reserved2
      case layer
      case alternateGroup
      case volume
      case matrix
      case width
      case height
    }

    override func encode(to encoder: Encoder) throws {
      try super.encode(to: encoder)
      var container = encoder.container(keyedBy: CodingKeys.self)

      try container.encode(type, forKey: .type)
      try container.encode(version, forKey: .version)
      try container.encode(flags, forKey: .flags)
      try container.encode(creationTime, forKey: .creationTime)
      try container.encode(modificationTime, forKey: .modificationTime)
      try container.encode(trackID, forKey: .trackID)
      try container.encode(duration, forKey: .duration)
      try container.encode(reserved1, forKey: .reserved1)
      try container.encode(reserved2, forKey: .reserved2)
      try container.encode(layer, forKey: .layer)
      try container.encode(alternateGroup, forKey: .alternateGroup)
      try container.encode(volume, forKey: .volume)
      try container.encode(matrix, forKey: .matrix)
      try container.encode(width, forKey: .width)
      try container.encode(height, forKey: .height)
    }
  }
}
