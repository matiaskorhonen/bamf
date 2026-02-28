import Foundation

extension Atom {
  /// Meta Box (ISO 14496-12 §8.11.1)
  public class META: Atom {
    /// Initialize a new `META` instance from raw atom data.
    ///
    /// - Parameter data: The raw data of the atom, excluding the size and type fields.
    public init(data: Data) {
      super.init(data: data, type: "meta")
      // meta is a full box; the first (headerSize - 8) bytes are version + flags, children follow
      self.children = (try? Bamf.parse(data[(data.startIndex + (headerSize - 8))..<data.endIndex])) ?? []
    }
  }
}
