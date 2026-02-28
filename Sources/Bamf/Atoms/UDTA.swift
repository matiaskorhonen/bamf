import Foundation

extension Atom {
  /// User Data Box (ISO 14496-12 §8.10.1)
  ///
  /// See also:
  /// - [QuickTime User Data Atom](https://developer.apple.com/documentation/quicktime-file-format/user_data_atom)
  /// - [QuickTime User Data Atoms](https://developer.apple.com/documentation/quicktime-file-format/user_data_atoms)
  public class UDTA: Atom {
    /// The parsed user-data entries contained in this box
    public var userData: [Atom] {
      return try! Bamf.parse(data[data.startIndex..<data.endIndex], isUserData: true)
    }

    override public var displayChildren: [Atom] {
      return userData
    }

    override public var debugDescription: String {
      "Atom(type=\(type), children=\(children.count), userData=\(userData))"
    }

    public init(data: Data) {
      super.init(data: data, type: "udta")
    }

    private enum CodingKeys: String, CodingKey {
      case type
      case userData
    }

    override public func encode(to encoder: Encoder) throws {
      try super.encode(to: encoder)
      var container = encoder.container(keyedBy: CodingKeys.self)

      try container.encode(type, forKey: .type)
      try container.encode(userData, forKey: .userData)
    }
  }
}
