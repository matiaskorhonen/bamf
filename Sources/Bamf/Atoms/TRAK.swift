import Foundation

extension Atom {
  /// Track Box (ISO 14496-12 §8.3.1)
  public class TRAK: Atom {
    /// Initialize a new `TRAK` instance from raw atom data.
    ///
    /// - Parameter data: The raw data of the atom, excluding the size and type fields.
    public init(data: Data) {
      super.init(data: data, type: "trak")
      self.children = try! Bamf.parse(data[(data.startIndex)..<data.endIndex])
    }
  }
}
