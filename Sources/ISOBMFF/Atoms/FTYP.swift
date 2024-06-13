import Foundation

extension Atom {
  class FTYP: Atom {
    var majorBrand: String? {
      let bytes = data[(data.startIndex)..<(data.startIndex + 4)]
      return String(data: bytes, encoding: .utf8)
    }
    var minorVersion: String {
      let bytes = [UInt8](data[(data.startIndex + 4)..<(data.startIndex + 12)])
      let century = String(bytes[0], radix: 16, uppercase: true)
      let year = String(bytes[1], radix: 16, uppercase: true)
      let month = String(bytes[2], radix: 16, uppercase: true)
      let zero = String(bytes[3], radix: 16, uppercase: true)

      return [century + year, month, zero].joined(separator: ".")
    }
    var compatibleBrands: [String] {
      var cursor = data.startIndex + 12
      var brands: [String?] = []
      while cursor < data.endIndex {
        let bytes = data[cursor..<(cursor + 4)]
        guard !bytes.allSatisfy({ UInt8($0) == 0 }) else {
          break
        }
        brands.append(String(data: bytes, encoding: .utf8))
        cursor += 4
      }
      return brands.compactMap { $0 }
    }
    override var debugDescription: String {
      return """
        Atom(
          type=\(type),
          children=\(children.count)
          majorBrand=\(majorBrand ?? "nil")
          minorVersion=\(minorVersion)
          compatibleBrands=\(compatibleBrands)
        )
        """
    }

    init(data: Data) {
      super.init(data: data, type: "ftyp")
    }

    private enum CodingKeys: String, CodingKey {
      case type
      case majorBrand
      case minorVersion
      case compatibleBrands
    }

    override func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(type, forKey: .type)
      try container.encode(majorBrand, forKey: .majorBrand)
      try container.encode(minorVersion, forKey: .minorVersion)
      try container.encode(compatibleBrands, forKey: .compatibleBrands)
    }
  }
}
