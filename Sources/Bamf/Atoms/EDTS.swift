import Foundation

extension Atom {
  /// Edit Box (ISO 14496-12 §8.6.4)
  public class EDTS: Atom {
    /// Initialize a new `EDTS` instance from raw atom data.
    ///
    /// - Parameter data: The raw data of the atom, excluding the size and type fields.
    public init(data: Data) {
      super.init(data: data, type: "edts")
      self.children = (try? Bamf.parse(data)) ?? []
    }
  }
}
