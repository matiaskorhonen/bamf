import Foundation

extension Atom {
  class MOOV: Atom {
    override var debugDescription: String {
      "Atom(type=\(type), children=\(children.count))"
    }

    init(data: Data) {
      super.init(data: data, type: "moov")
      self.children = try! ISOBMFF.parse(data[(data.startIndex)..<data.endIndex])
    }
  }
}
