import Foundation

extension Atom {
  /// Free Space Box (ISO 14496-12 §8.1.2)
  public class FREE: Atom {
    init(data: Data) {
      super.init(data: data, type: "free")
    }
  }
}
