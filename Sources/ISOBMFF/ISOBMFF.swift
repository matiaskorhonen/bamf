import Foundation

struct ISOBMFF: Encodable {
  enum Error: Swift.Error {
    case invalidAtomSize(String)
  }

  @CodableIgnored
  var data: Data!

  let children: [Atom]

  init(_ url: URL) {
    let data = try! Data(contentsOf: url, options: .alwaysMapped)
    children = try! ISOBMFF.parse(data)
    self.data = data
  }

  static func parse(_ data: Data) throws -> [Atom] {
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

      let atom = Atom.from(type: atomType, data: atomData)

      atoms.append(atom)

      cursor += Int(size)
    }

    return atoms
  }
}
