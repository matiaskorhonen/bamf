import Foundation

extension Atom {
  public class EDTS: Atom {
    public init(data: Data) {
      super.init(data: data, type: "edts")
      self.children = (try? Bamf.parse(data)) ?? []
    }
  }
}
