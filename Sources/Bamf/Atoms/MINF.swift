import Foundation

extension Atom {
  public class MINF: Atom {
    public init(data: Data) {
      super.init(data: data, type: "minf")
      self.children = (try? Bamf.parse(data[(data.startIndex)..<data.endIndex])) ?? []
    }
  }
}
