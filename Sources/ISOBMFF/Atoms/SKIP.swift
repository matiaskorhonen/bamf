import Foundation

extension Atom {
  class SKIP: Atom, WithDataInit {
    required init(data: Data) {
      super.init(data: data, type: .skip)
    }
  }
}
