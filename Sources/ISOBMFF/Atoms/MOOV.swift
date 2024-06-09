import Foundation

extension Atom {
  class MOOV: Atom, WithDataInit {
    override var debugDescription: String {
      "Atom(type=\(type), children=\(children.count))"
    }

    required init(data: Data) {
      super.init(data: data, type: .moov)
      self.children = try! ISOBMFF.parse(data[(data.startIndex)..<data.endIndex])
    }
  }
}
