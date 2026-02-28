import Foundation

extension Atom {
  /// Wide Box — a placeholder box used to reserve space for an extended-size `mdat` box
  class WIDE: Atom {
    init(data: Data) {
      super.init(data: data, type: "wide")
    }
  }
}
