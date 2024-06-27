import Foundation

extension Atom {
  class UserData: Atom {

    var languageEncoding: String.Encoding? {
      guard let value = self.languageCodeValue else {
        return nil
      }

      if value <= 40 || value == 0x7FFF {
        return String.Encoding.macOSRoman
      }

      return String.Encoding.utf8  // TODO: Handle UTF-16
    }

    // https://developer.apple.com/documentation/quicktime-file-format/language_code_values
    var languageCodeValue: UInt16? {
      guard self.type.starts(with: "©") else {
        return nil
      }

      return data[(data.startIndex)..<(data.startIndex + 2)].asInteger()
    }

    // Returns the string data without any null bytes and skipping over the langauge and size fields
    private var stringData: Data {
      let lastNonNull = data.lastIndex(where: { $0 != 0 }) ?? data.endIndex
      return data[(data.startIndex + 4)..<(lastNonNull)]
    }

    var stringValue: String? {
      guard let encoding = languageEncoding else {
        return nil
      }

      // Ensure that there is non-null data
      guard !stringData.starts(with: [0]) else {
        return nil
      }

      return String(data: stringData, encoding: encoding)
    }

    private enum CodingKeys: String, CodingKey {
      case type
      case stringValue
      case languageCodeValue
    }

    override func encode(to encoder: Encoder) throws {
      try super.encode(to: encoder)
      var container = encoder.container(keyedBy: CodingKeys.self)

      try container.encode(type, forKey: .type)
      try container.encode(stringValue, forKey: .stringValue)
      try container.encode(languageCodeValue, forKey: .languageCodeValue)
    }

    // TODO: Fix UserData handling
    //
    // https://developer.apple.com/documentation/quicktime-file-format/user_data_atoms#User-data-text-strings-and-language-codes
    //
    // var stringValue: String? {
    //   // Ensure that there is non-null data
    //   let firstNonNull = data.firstIndex(where: { $0 != 0 }) ?? data.startIndex
    //   let startTrimmed = data[firstNonNull...]
    //   guard startTrimmed.count > 0 else { return nil }

    //   let lastNonNull = startTrimmed.lastIndex(where: { $0 != 0 }) ?? startTrimmed.endIndex
    //   let trimmed = startTrimmed[..<lastNonNull]

    //   return String(data: trimmed, encoding: .utf8)
    // }
    // var dateValue: Date? {
    //   guard data.count == 4 else { return nil }

    //   return data.asDate()
    // }
    // var integerValue: UInt64? {
    //   // Only handle ≤ 64-bit data as a possible integer
    //   guard data.count <= (UInt64.bitWidth / UInt8.bitWidth) else { return nil }

    //   return data.asInteger()
    // }

    // private enum CodingKeys: String, CodingKey {
    //   case type
    //   case stringValue
    //   case dateValue
    //   case integerValue
    // }

    // override func encode(to encoder: Encoder) throws {
    //   var container = encoder.container(keyedBy: CodingKeys.self)
    //   try container.encode(type, forKey: .type)
    //   try container.encode(stringValue, forKey: .stringValue)
    //   try container.encode(dateValue, forKey: .dateValue)
    //   try container.encode(integerValue, forKey: .integerValue)
    // }
  }
}
