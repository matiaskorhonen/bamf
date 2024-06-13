import Foundation

extension Atom {
  class MOOV: Atom {
    init(data: Data) {
      super.init(data: data, type: "moov")
      self.children = try! ISOBMFF.parse(data[(data.startIndex)..<data.endIndex])
    }
  }
}
