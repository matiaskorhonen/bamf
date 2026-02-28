import Foundation

extension Atom {
  /// Media Box (ISO 14496-12 §8.4.1)
  public class MDIA: Atom {
    /// Initialize a new `MDIA` instance from raw atom data.
    ///
    /// - Parameter data: The raw data of the atom, excluding the size and type fields.
    public init(data: Data) {
      super.init(data: data, type: "mdia")
      self.children = (try? Bamf.parse(data[(data.startIndex)..<data.endIndex])) ?? []
    }
  }
}
