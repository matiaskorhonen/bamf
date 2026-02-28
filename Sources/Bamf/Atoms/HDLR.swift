import Foundation

extension Atom {
  /// Handler Reference Box (ISO 14496-12 §8.4.3)
  public class HDLR: Atom {
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
    /// Handler type (e.g. "vide", "soun", "hint")
    public var handlerType: String {
      let bytes = data[(data.startIndex + 8)..<(data.startIndex + 12)]
      return String(data: bytes, encoding: .macOSRoman) ?? ""
    }
    /// Human-readable name for the handler
    public var name: String {
      guard data.count > 24 else { return "" }
      let nameData = data[(data.startIndex + 24)..<data.endIndex]
      guard !nameData.isEmpty else { return "" }
      let firstByte = nameData[nameData.startIndex]
      // Detect QuickTime Pascal string: first byte equals remaining byte count minus one
      if Int(firstByte) == nameData.count - 1 {
        let pascalData = nameData[(nameData.startIndex + 1)..<(nameData.startIndex + 1 + Int(firstByte))]
        let trimmed = pascalData.prefix(while: { $0 != 0 })
        return String(data: trimmed, encoding: .utf8) ?? ""
      }
      // ISO 14496-12: null-terminated UTF-8 string
      let trimmed = nameData.prefix(while: { $0 != 0 })
      return String(data: trimmed, encoding: .utf8) ?? ""
    }

    override public var debugDescription: String {
      return """
        Atom(
          type=\(type),
          version=\(version)
          flags=\(flags)
          handlerType=\(handlerType)
          name=\(name)
        )
        """
    }

    public init(data: Data) {
      super.init(data: data, type: "hdlr")
    }

    private enum CodingKeys: String, CodingKey {
      case type
      case version
      case flags
      case handlerType
      case name
    }

    override public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(type, forKey: .type)
      try container.encode(version, forKey: .version)
      try container.encode(flags, forKey: .flags)
      try container.encode(handlerType, forKey: .handlerType)
      try container.encode(name, forKey: .name)
    }
  }
}
