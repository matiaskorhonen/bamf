import Foundation

struct ISOBMFF {
  let data: Data
  let children: [Atom]

  init(_ url: URL) {
    self.data = try! Data(contentsOf: url, options: .alwaysMapped)
    children = ISOBMFF.parse(self.data)
  }

  static func parse(_ data: Data) -> [Atom] {
    var cursor: Int = data.startIndex
    var atoms: [Atom] = []

    while cursor < data.endIndex {
      let sizeBytes = [UInt8](data[cursor..<(cursor + 4)])

      var size = sizeBytes.reduce(0) { soFar, byte in
        return soFar << 8 | UInt64(byte)
      }

      // https://github.com/corkami/formats/blob/master/container/mp4.md
      var dataStartIndex = cursor + 8  // Skip the size and type fields
      var dataEndIndex = cursor + Int(size)
      if size == 0 {
        // Size = null → read until the end of the file
        size = UInt64(data.endIndex) - UInt64(cursor + 8)
        dataEndIndex = data.endIndex
      } else if size == 1 {
        // Size = 1 → extended size
        let extendedSizeBytes = [UInt8](data[(cursor + 8)..<(cursor + 16)])
        size = extendedSizeBytes.reduce(0) { soFar, byte in
          return soFar << 8 | UInt64(byte)
        }
        dataStartIndex = cursor + 16
        dataEndIndex = cursor + Int(size)
      }

      // Get the atom type
      let atomType = Atom.atomType(from: Data(data[(cursor + 4)..<(cursor + 8)]))

      // Get the data without the size and type fields
      let atomData = data[dataStartIndex..<(dataEndIndex)]

      let atom = Atom.from(type: atomType, data: atomData)

      atoms.append(atom)
      // if atom.data.count < 128 {
      //   print("Atom: \(atom.type) \(atom.data.base64EncodedString())")
      // }

      cursor += Int(size)
    }

    return atoms
  }
}
