import Foundation

extension Atom {
  class MOOV: Atom {
    init(data: Data) {
      super.init(data: data, type: "moov")
      self.children = try! Bamf.parse(data[(data.startIndex)..<data.endIndex])
    }
  }
}
