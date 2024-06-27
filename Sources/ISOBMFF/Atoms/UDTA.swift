import Foundation

extension Atom {
  class UDTA: Atom {
    // https://developer.apple.com/documentation/quicktime-file-format/user_data_atom
    // https://developer.apple.com/documentation/quicktime-file-format/user_data_atoms
    var userData: [Atom] {
      return try! Bamf.parse(data[data.startIndex..<data.endIndex], isUserData: true)
    }

    override var debugDescription: String {
      "Atom(type=\(type), children=\(children.count), userData=\(userData))"
    }

    init(data: Data) {
      super.init(data: data, type: "udta")
    }

    private enum CodingKeys: String, CodingKey {
      case type
      case userData
    }

    override func encode(to encoder: Encoder) throws {
      try super.encode(to: encoder)
      var container = encoder.container(keyedBy: CodingKeys.self)

      try container.encode(type, forKey: .type)
      try container.encode(userData, forKey: .userData)
    }
  }
}
