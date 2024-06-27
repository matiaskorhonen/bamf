import Foundation

public class Atom: Encodable, CustomDebugStringConvertible {
  public let type: String

  @CodableIgnored
  public var data: Data!

  public var children: [Atom] = []

  public var debugDescription: String {
    "Atom(type=\(type), children=\(children.count))"
  }

  public init(data: Data, type: String) {
    self.data = data
    self.type = type
  }

  static func from(type: String, data: Data) -> Atom {
    switch type {
    case "ftyp":
      return FTYP(data: data)
    case "mdat":
      return MDAT(data: data)
    case "wide":
      return WIDE(data: data)
    case "free":
      return FREE(data: data)
    case "skip":
      return SKIP(data: data)
    case "mdhd":
      return MDHD(data: data)
    case "mvhd":
      return MVHD(data: data)
    case "moov":
      return MOOV(data: data)
    case "trak":
      return TRAK(data: data)
    case "tkhd":
      return TKHD(data: data)
    case "mdia":
      return MDIA(data: data)
    case "hdlr":
      return HDLR(data: data)
    case "minf":
      return MINF(data: data)
    case "vmhd":
      return VMHD(data: data)
    case "dinf":
      return DINF(data: data)
    case "dref":
      return DREF(data: data)
    case "stbl":
      return STBL(data: data)
    case "stsd":
      return STSD(data: data)
    case "stts":
      return STTS(data: data)
    case "stss":
      return STSS(data: data)
    case "stsc":
      return STSC(data: data)
    case "stsz":
      return STSZ(data: data)
    case "stco":
      return STCO(data: data)
    case "udta":
      return UDTA(data: data)
    default:
      return Unknown(data: data, type: type)
    }
  }

  static func atomType(from typeBytes: Data) -> String {
    guard let typeStr = String(data: typeBytes, encoding: .macOSRoman) else {
      return "[\(typeBytes.hex)]"
    }

    return typeStr
  }
}
