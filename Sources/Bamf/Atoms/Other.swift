import Foundation

// MARK: All atoms that don't have a specific implementation yet
extension Atom {
  /// Sample Description Box (ISO 14496-12 §8.5.2)
  public class STSD: Atom {
    public init(data: Data) {
      super.init(data: data, type: "stsd")
    }
  }
  public class Unknown: Atom {}
}
