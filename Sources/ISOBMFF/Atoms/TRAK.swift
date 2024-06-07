import Foundation

extension Atom {
  class TRAK: Atom, WithDataInit {
    override var debugDescription: String {
      "Atom(type=\(type), children=\(children.count))"
    }

    required init(data: Data) {
      super.init(data: data, type: .trak)
      self.children = ISOBMFF.parse(data[(data.startIndex + 8)..<data.endIndex])
    }
  }
}
