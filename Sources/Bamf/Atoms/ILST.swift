import Foundation

extension Atom {
  /// iTunes Metadata List Box
  ///
  /// Contains a list of metadata items (e.g. `.cmt`), each of which holds one or
  /// more `data` sub-atoms carrying the actual value.
  public class ILST: Atom {
    /// Initialize a new `ILST` instance from raw atom data.
    ///
    /// - Parameter data: The raw data of the atom, excluding the size and type fields.
    public init(data: Data) {
      super.init(data: data, type: "ilst")
      // Parse each child as an ILSTItem (a generic container holding `data` atoms)
      var items: [Atom] = []
      var cursor = data.startIndex
      while cursor + 8 <= data.endIndex {
        let size: UInt32 = data[cursor..<(cursor + 4)].asInteger()
        guard size >= 8, cursor + Int(size) <= data.endIndex else { break }
        let itemType = Atom.atomType(from: Data(data[(cursor + 4)..<(cursor + 8)]))
        let itemData = data[(cursor + 8)..<(cursor + Int(size))]
        items.append(ILSTItem(data: itemData, type: itemType))
        cursor += Int(size)
      }
      self.children = items
    }
  }

  /// A generic iTunes metadata item (e.g. `.cmt`) parsed from an `ilst` box.
  ///
  /// Contains one or more `data` sub-atoms.
  public class ILSTItem: Atom {
    override init(data: Data, type: String) {
      super.init(data: data, type: type)
      self.children = (try? Bamf.parse(data)) ?? []
    }
  }

  /// The `data` sub-atom inside an iTunes metadata item.
  ///
  /// Carries a well-known type indicator, a locale, and the raw value bytes.
  public class ILSTData: Atom {
    /// Well-known data type indicator (1 = UTF-8, 13 = JPEG, 14 = PNG, …)
    public var dataType: UInt32 {
      guard data.count >= 4 else { return 0 }
      return data[data.startIndex..<(data.startIndex + 4)].asInteger()
    }

    /// Locale field (language + country packed as a 32-bit integer)
    public var locale: UInt32 {
      guard data.count >= 8 else { return 0 }
      return data[(data.startIndex + 4)..<(data.startIndex + 8)].asInteger()
    }

    /// The string value when `dataType` indicates a text encoding (1 = UTF-8).
    public var value: String? {
      guard data.count > 8 else { return nil }
      let valueData = data[(data.startIndex + 8)..<data.endIndex]
      switch dataType {
      case 1:
        return String(data: valueData, encoding: .utf8)
      default:
        return nil
      }
    }

    public init(data: Data) {
      super.init(data: data, type: "data")
    }

    private enum CodingKeys: String, CodingKey {
      case type
      case dataType
      case locale
      case value
    }

    override public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(type, forKey: .type)
      try container.encode(dataType, forKey: .dataType)
      try container.encode(locale, forKey: .locale)
      if let value = value {
        try container.encode(value, forKey: .value)
      }
    }
  }
}
