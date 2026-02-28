import Foundation

extension Atom {
  /// Skip Box (ISO 14496-12 §8.1.2); semantically identical to the `free` box
  class SKIP: Atom {
    init(data: Data) {
      super.init(data: data, type: "skip")
    }
  }
}
