import Foundation

extension Atom {
  class WIDE: Atom, WithDataInit {
    required init(data: Data) {
      super.init(data: data, type: .wide)
    }
  }
}
