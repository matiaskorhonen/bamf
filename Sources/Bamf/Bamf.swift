import Foundation

/// A struct representing an ISOBMFF file
public struct Bamf: Encodable {
  enum Error: Swift.Error {
    case invalidAtomSize(String)
  }

  @CodableIgnored
  var data: Data!

  /// The root atoms of the file
  public let children: [Atom]

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
      var size: UInt64 = data[cursor..<(cursor + 4)].asInteger()

      // https://github.com/corkami/formats/blob/master/container/mp4.md
      var dataStartIndex = cursor + 8  // Skip the size and type fields
      var dataEndIndex = cursor + Int(size)
      if size == 0 {
        // Size = null → read until the end of the file
        size = UInt64(data.endIndex) - UInt64(cursor + 8)
        dataEndIndex = data.endIndex
      } else if size == 1 {
        // Size = 1 → extended size
        size = data[(cursor + 8)..<(cursor + 16)].asInteger()
        dataStartIndex = cursor + 16
        dataEndIndex = cursor + Int(size)
      }

      guard size >= 8 else {
        print("Invalid atom size: \(size)")
        throw Error.invalidAtomSize("Invalid atom size \(size) at offset \(cursor)")
      }

      // Get the atom type
      let atomType = Atom.atomType(from: Data(data[(cursor + 4)..<(cursor + 8)]))

      // Get the data without the size and type fields
      let atomData = data[dataStartIndex..<(dataEndIndex)]

      if isUserData {
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
