import Foundation

extension Atom {
  public class TRAK: Atom {
    public init(data: Data) {
      super.init(data: data, type: "trak")
      self.children = try! Bamf.parse(data[(data.startIndex)..<data.endIndex])
    }
  }
}
