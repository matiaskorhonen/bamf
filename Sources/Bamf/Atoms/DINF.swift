import Foundation

extension Atom {
  public class DINF: Atom {
    public init(data: Data) {
      super.init(data: data, type: "dinf")
      self.children = (try? Bamf.parse(data[(data.startIndex)..<data.endIndex])) ?? []
    }
  }
}
