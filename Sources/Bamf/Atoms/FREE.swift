import Foundation

extension Atom {
  public class FREE: Atom {
    init(data: Data) {
      super.init(data: data, type: "free")
    }
  }
}
