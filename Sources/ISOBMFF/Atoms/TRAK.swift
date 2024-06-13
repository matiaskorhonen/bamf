import Foundation

extension Atom {
  class TRAK: Atom {
    override var debugDescription: String {
      "Atom(type=\(type), children=\(children.count))"
    }

    init(data: Data) {
      super.init(data: data, type: "trak")
      self.children = try! ISOBMFF.parse(data[(data.startIndex)..<data.endIndex])
    }
  }
}
