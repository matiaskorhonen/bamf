import Foundation

extension Atom {
  class TKHD: Atom, WithDataInit {
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
      data[(data.startIndex + 4)..<(data.startIndex + 8)].asDate()
    }
    var modificationTime: Date {
      data[(data.startIndex + 8)..<(data.startIndex + 12)].asDate()
    }
    var trackID: UInt32 {
      return 0
    }
    var reserved1: UInt32 {
      return 0
    }
    var duration: UInt32 {
      return 0
    }
    var reserved2: UInt32 {
      return 0
    }
    var layer: UInt32 {
      return 0
    }
    var alternateGroup: UInt32 {
      return 0
    }
    var volume: Float {
      return 0
    }
    var matrix: String {
      return ""
    }
    var width: UInt32 {
      return 0
    }
    var height: UInt32 {
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

    required init(data: Data) {
      super.init(data: data, type: .tkhd)
    }
  }
}
