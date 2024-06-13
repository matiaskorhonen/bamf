import Foundation

extension Atom {
  class FREE: Atom {
    init(data: Data) {
      super.init(data: data, type: "free")
    }
  }
}
