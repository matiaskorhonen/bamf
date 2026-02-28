import Foundation

extension Atom {
  /// Sample Table Box (ISO 14496-12 §8.5.1)
  public class STBL: Atom {
    /// Initialize a new `STBL` instance from raw atom data.
    ///
    /// - Parameter data: The raw data of the atom, excluding the size and type fields.
    public init(data: Data) {
      super.init(data: data, type: "stbl")
      self.children = (try? Bamf.parse(data[(data.startIndex)..<data.endIndex])) ?? []
    }
  }
}
