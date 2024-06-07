import Foundation

extension Atom {
  class FREE: Atom, WithDataInit {
    required init(data: Data) {
      super.init(data: data, type: .free)
    }
  }
}
