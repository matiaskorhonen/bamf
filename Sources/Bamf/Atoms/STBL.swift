import Foundation

extension Atom {
  public class STBL: Atom {
    public init(data: Data) {
      super.init(data: data, type: "stbl")
      self.children = (try? Bamf.parse(data[(data.startIndex)..<data.endIndex])) ?? []
    }
  }
}
