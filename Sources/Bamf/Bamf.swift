import Foundation

/// A struct representing an ISOBMFF file
public struct Bamf: Encodable, AtomSearchable {
  /// Errors that can be thrown when parsing ISOBMFF data.
  enum Error: Swift.Error {
    /// The atom size field contains an invalid value.
    ///
    /// - Parameter description: A human-readable description of the error including the invalid size and file offset.
    case invalidAtomSize(String)
  }

  @CodableIgnored
  var data: Data!

  /// The root atoms of the file
  public let children: [Atom]

  /// Children to traverse when recursively searching for atoms.
  public var atomSearchChildren: [Atom] {
    children
  }

  /// Create a new `Bamf` instance from a local file URL
  ///
  /// - Parameter url: A local file URL to a MP4, MOV, or other ISOBMFF file
  public init(_ url: URL) throws {
    let data = try Data(contentsOf: url, options: .alwaysMapped)
    children = try Bamf.parse(data)
    self.data = data
  }

  /// Parse the given data
  ///
  /// - Parameters:
  ///  - data: ISOBMFF data
  ///  - isUserData: Whether the data is user data (used for parsing `udta` atoms)
  public static func parse(_ data: Data, isUserData: Bool = false) throws -> [Atom] {
    var cursor: Int = data.startIndex
    var atoms: [Atom] = []

    while cursor < data.endIndex {
      guard cursor + 8 <= data.endIndex else {
        throw Error.invalidAtomSize("Incomplete atom header at offset \(cursor)")
      }

      var size: UInt64 = data[cursor..<(cursor + 4)].asInteger()

      // https://github.com/corkami/formats/blob/master/container/mp4.md
      var dataStartIndex = cursor + 8  // Skip the size and type fields
      var dataEndIndex = cursor + Int(size)
      if size == 0 {
        // Size = null → read until the end of the file
        size = UInt64(data.endIndex - cursor)
        dataEndIndex = data.endIndex
      } else if size == 1 {
        // Size = 1 → extended size
        guard cursor + 16 <= data.endIndex else {
          throw Error.invalidAtomSize("Incomplete extended atom header at offset \(cursor)")
        }
        size = data[(cursor + 8)..<(cursor + 16)].asInteger()
        dataStartIndex = cursor + 16
      }

      let headerSize = UInt64(dataStartIndex - cursor)
      guard size >= headerSize else {
        print("Invalid atom size: \(size)")
        throw Error.invalidAtomSize("Invalid atom size \(size) at offset \(cursor)")
      }

      guard size <= UInt64(data.endIndex - cursor) else {
        throw Error.invalidAtomSize("Atom size \(size) at offset \(cursor) exceeds available data")
      }

      dataEndIndex = cursor + Int(size)

      // Get the atom type
      let atomType = Atom.atomType(from: Data(data[(cursor + 4)..<(cursor + 8)]))

      // Get the data without the size and type fields
      let atomData = data[dataStartIndex..<(dataEndIndex)]

      if isUserData && atomType != "meta" {
        let atom = Atom.UserData(data: atomData, type: atomType)
        atoms.append(atom)
      } else {
        let atom = Atom.from(type: atomType, data: atomData)
        atoms.append(atom)
      }

      cursor += Int(size)
    }

    return atoms
  }
}
