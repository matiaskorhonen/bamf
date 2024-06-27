import Foundation

extension Atom {
  public class MDAT: Atom {
    init(data: Data) {
      super.init(data: data, type: "mdat")
    }
  }
}
