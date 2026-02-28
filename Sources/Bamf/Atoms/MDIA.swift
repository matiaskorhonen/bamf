import Foundation

extension Atom {
  public class MDIA: Atom {
    public init(data: Data) {
      super.init(data: data, type: "mdia")
      self.children = (try? Bamf.parse(data[(data.startIndex)..<data.endIndex])) ?? []
    }
  }
}
