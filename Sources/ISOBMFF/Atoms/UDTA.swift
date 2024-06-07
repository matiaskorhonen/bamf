import Foundation

extension Atom {
  class UDTA: Atom, WithDataInit {
    // https://developer.apple.com/documentation/quicktime-file-format/user_data_atom
    // https://developer.apple.com/documentation/quicktime-file-format/user_data_atoms
    var userData: [Atom] {
      return ISOBMFF.parse(data[data.startIndex..<data.endIndex])
    }

    override var debugDescription: String {
      "Atom(type=\(type), children=\(children.count), userData=\(userData))"
    }

    required init(data: Data) {
      super.init(data: data, type: .udta)
    }
  }
}
