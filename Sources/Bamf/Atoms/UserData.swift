import Foundation

extension Atom {
  /// A generic user-data entry atom (e.g. `©nam`, `©day`) parsed from a `udta` box.
  class UserData: Atom {

    /// The string encoding inferred from the language code, or `nil` if the atom is not a string atom.
    var stringEncoding: String.Encoding? {
      guard let value = self.languageCodeValue else {
        return nil
      }

      guard stringData.count > 0 else {
        return nil
      }

      if value <= 40 || value == 0x7FFF {
        return String.Encoding.macOSRoman
      }

      // If the data starts with the BOM, it's UTF-16
      if stringData.starts(with: [0x7F, 0xFF]) {
        return String.Encoding.utf16
      }

      return String.Encoding.utf8
    }

    // https://developer.apple.com/documentation/quicktime-file-format/language_code_values
    private var languageCodeValue: UInt16? {
      guard self.type.starts(with: "©") else {
        return nil
      }

      return data[(data.startIndex)..<(data.startIndex + 2)].asInteger()
    }

    // Returns the string data without any null bytes and skipping over the language and size fields
    private var stringData: Data {
      let lastNonNull = data.lastIndex(where: { $0 != 0 }) ?? data.endIndex
      return data[(data.startIndex + 4)..<(lastNonNull)]
    }

    /// The decoded string value of this atom, or `nil` if the atom does not contain a string.
    var stringValue: String? {
      guard let encoding = stringEncoding else {
        return nil
      }

      // Ensure that there is non-null data
      guard !stringData.starts(with: [0]) else {
        return nil
      }

      return String(data: stringData, encoding: encoding)
    }

    /// The date value of this atom, or `nil` if the atom does not contain a 4-byte Mac epoch timestamp.
    var dateValue: Date? {
      guard data.count == 4 else { return nil }

      return data.asDate()
    }

    /// The integer value of this atom, or `nil` if the data is larger than 64 bits.
    var integerValue: UInt64? {
      // Only handle ≤ 64-bit data as a possible integer
      guard data.count <= (UInt64.bitWidth / UInt8.bitWidth) else { return nil }

      return data.asInteger()
    }

    private enum CodingKeys: String, CodingKey {
      case type
      case stringEncoding
      case stringValue
      case dateValue
      case integerValue
      case data
    }

    override func encode(to encoder: Encoder) throws {
      try super.encode(to: encoder)
      var container = encoder.container(keyedBy: CodingKeys.self)

      try container.encode(type, forKey: .type)

      if let stringValue = stringValue {
        if let encoding = stringEncoding {
          var encodingStr: String!

          switch encoding {
          case .macOSRoman:
            encodingStr = "macintosh"
          case .utf8:
            encodingStr = "utf8"
          case .utf16:
            encodingStr = "utf16"
          default:
            encodingStr = "unknown"
          }

          try container.encode(encodingStr, forKey: .stringEncoding)
        }

        try container.encode(stringValue, forKey: .stringValue)
      }
      if let dateValue = dateValue {
        try container.encode(dateValue, forKey: .dateValue)
      }
      if let integerValue = integerValue {
        try container.encode(integerValue, forKey: .integerValue)
      }

      let endIndex = min(data.startIndex + 64, data.endIndex)
      var hexData = data[data.startIndex..<(endIndex)].hex

      if data.count > 64 {
        hexData += "... and \(data.count) more byte(s)"
      }

      try container.encode(hexData, forKey: .data)
    }
  }
}
