import Foundation

extension Atom {
  class SKIP: Atom {
    init(data: Data) {
      super.init(data: data, type: "skip")
    }
  }
}
