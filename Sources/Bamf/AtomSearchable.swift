import Foundation

/// A type that can recursively search through atom children.
public protocol AtomSearchable {
  /// Children to traverse when recursively searching for atoms.
  var atomSearchChildren: [Atom] { get }
}

extension AtomSearchable {
  /// Recursively finds the first atom matching the given atom class.
  ///
  /// - Parameter atomClass: The atom class to find, for example `MDIA.self`.
  /// - Returns: The first matching atom, or `nil` if no match is found.
  public func findAtom<T: Atom>(ofType atomClass: T.Type) -> T? {
    for child in atomSearchChildren {
      if let match = child as? T {
        return match
      }

      if let match = child.findAtom(ofType: atomClass) {
        return match
      }
    }

    return nil
  }
}
