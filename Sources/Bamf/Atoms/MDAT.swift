import Foundation

extension Atom {
  class MDAT: Atom {
    init(data: Data) {
      super.init(data: data, type: "mdat")
    }
  }
}
