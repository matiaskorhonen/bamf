import Foundation

protocol WithDataInit {
  init(data: Data)
}

class Atom: CustomDebugStringConvertible {
  let type: AtomType
  let data: Data
  var binary: Bool = false
  var unknown: Bool = false

  var children: [Atom] = []

  var debugDescription: String {
    "Atom(type=\(type), children=\(children.count))"
  }

  init(data: Data, type: AtomType) {
    self.data = data
    self.type = type
  }

  static func from(type: AtomType, data: Data) -> Atom {
    switch type {
    case .ftyp:
      return FTYP(data: data)
    case .mdat:
      return MDAT(data: data)
    case .wide:
      return WIDE(data: data)
    case .free:
      return FREE(data: data)
    case .skip:
      return SKIP(data: data)
    case .mdhd:
      return MDHD(data: data)
    case .mvhd:
      return MVHD(data: data)
    case .moov:
      return MOOV(data: data)
    case .trak:
      return TRAK(data: data)
    case .tkhd:
      return TKHD(data: data)
    case .mdia:
      return MDIA(data: data)
    case .hdlr:
      return HDLR(data: data)
    case .minf:
      return MINF(data: data)
    case .vmhd:
      return VMHD(data: data)
    case .dinf:
      return DINF(data: data)
    case .dref:
      return DREF(data: data)
    case .stbl:
      return STBL(data: data)
    case .stsd:
      return STSD(data: data)
    case .stts:
      return STTS(data: data)
    case .stss:
      return STSS(data: data)
    case .stsc:
      return STSC(data: data)
    case .stsz:
      return STSZ(data: data)
    case .stco:
      return STCO(data: data)
    case .udta:
      return UDTA(data: data)
    case .unknown:
      return Unknown(data: data, type: type)
    }
  }

  static func atomType(from typeBytes: Data) -> AtomType {
    guard let typeStr = String(data: typeBytes, encoding: .macOSRoman) else {
      return .unknown("[\(typeBytes.hex)]")
    }

    return atomType(from: typeStr)
  }

  static func atomType(from typeStr: String) -> AtomType {
    guard let type = AtomType.allCases.first(where: { String(describing: $0) == typeStr }) else {
      return .unknown(typeStr)
    }

    return type
  }

  static func parseAtomType(from data: Data) -> AtomType {
    let typeBytes = data[(data.startIndex + 4)..<(data.startIndex + 8)]

    guard let typeStr = String(data: typeBytes, encoding: .macOSRoman) else {
      return .unknown("[\(typeBytes.hex)]")
    }

    guard let type = AtomType.allCases.first(where: { String(describing: $0) == typeStr }) else {
      return .unknown(typeStr)
    }

    return type
  }
}
