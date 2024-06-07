import Foundation

extension Atom {
  class MDAT: Atom, WithDataInit {
    required init(data: Data) {
      super.init(data: data, type: .mdat)
    }
  }
}
