import Foundation

extension Atom {
  /// Movie Box (ISO 14496-12 §8.2.1)
  public class MOOV: Atom {
    /// Initialize a new `MOOV` instance from raw atom data.
    ///
    /// - Parameter data: The raw data of the atom, excluding the size and type fields.
    public init(data: Data) {
      super.init(data: data, type: "moov")
      self.children = try! Bamf.parse(data[(data.startIndex)..<data.endIndex])
    }
  }
}
