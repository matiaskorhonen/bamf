import Foundation

extension Atom {
  class TRAK: Atom {
    init(data: Data) {
      super.init(data: data, type: "trak")
      self.children = try! ISOBMFF.parse(data[(data.startIndex)..<data.endIndex])
    }
  }
}
