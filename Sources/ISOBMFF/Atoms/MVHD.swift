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
  }
}
