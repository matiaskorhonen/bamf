import Foundation

/// A struct representing an ISOBMFF atom or box.
public class Atom: Encodable, CustomDebugStringConvertible {
  /// A four character string representing the type of the atom.
  public let type: String

  /// The raw data of the atom or box.
  @CodableIgnored
  public var data: Data!

  /// The children atoms or boxes, if applicable.
  public var children: [Atom] = []

  /// A textual representation of this instance, suitable for debugging.
  public var debugDescription: String {
    "Atom(type=\(type), children=\(children.count))"
  }

  /// Initialize a new `Atom` instance with the given data and type.
  ///
  /// - Parameters:
  ///   - data: The raw data of the atom or box. The data should not include the size or type fields.
  ///   - type: A four character string representing the type of the atom.
  public init(data: Data, type: String) {
    self.data = data
    self.type = type
  }

  /// Initialize a new `Atom` instance with the appropriate subclass for the given type.
  ///
  /// - Parameters:
  ///   - data: The raw data of the atom or box. The data should not include the size or type fields.
  ///   - type: A four character string representing the type of the atom.
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
    case "smhd":
      return SMHD(data: data)
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

  /// Get the atom type from the given four character string. Returns a hex
  /// representation of the type if the type is not a valid string.
  static func atomType(from typeBytes: Data) -> String {
    guard let typeStr = String(data: typeBytes, encoding: .macOSRoman) else {
      return "[\(typeBytes.hex)]"
    }

    return typeStr
  }
}
