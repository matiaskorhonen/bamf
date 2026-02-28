import Foundation

// MARK: All atoms that don't have a specific implementation yet
extension Atom {
  /// Sample Description Box (ISO 14496-12 §8.5.2)
  public class STSD: Atom {
    /// Number of sample entries
    public var entryCount: UInt32 {
      guard data.count >= 8 else { return 0 }
      return data[(data.startIndex + 4)..<(data.startIndex + 8)].asInteger()
    }

    public init(data: Data) {
      super.init(data: data, type: "stsd")
    }
  }
  public class Unknown: Atom {}
}
