import Foundation

extension Atom {
  /// Media Information Box (ISO 14496-12 §8.4.4)
  public class MINF: Atom {
    /// Initialize a new `MINF` instance from raw atom data.
    ///
    /// - Parameter data: The raw data of the atom, excluding the size and type fields.
    public init(data: Data) {
      super.init(data: data, type: "minf")
      self.children = (try? Bamf.parse(data[(data.startIndex)..<data.endIndex])) ?? []
    }
  }
}
