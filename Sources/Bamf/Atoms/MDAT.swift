import Foundation

extension Atom {
  /// Media Data Box (ISO 14496-12 §8.2.2)
  public class MDAT: Atom {
    init(data: Data) {
      super.init(data: data, type: "mdat")
    }
  }
}
