import Foundation

extension Atom {
  class WIDE: Atom {
    init(data: Data) {
      super.init(data: data, type: "wide")
    }
  }
}
