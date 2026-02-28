import Foundation

extension Atom {
  /// Data Information Box (ISO 14496-12 §8.7.1)
  public class DINF: Atom {
    /// Initialize a new `DINF` instance from raw atom data.
    ///
    /// - Parameter data: The raw data of the atom, excluding the size and type fields.
    public init(data: Data) {
      super.init(data: data, type: "dinf")
      self.children = (try? Bamf.parse(data[(data.startIndex)..<data.endIndex])) ?? []
    }
  }
}
