# Using Bamf

Learn the basic workflow for parsing an ISOBMFF file and inspecting its atom hierarchy.

## Parse a file URL

Create a ``Bamf`` instance from a local file URL:

```swift
import Bamf
import Foundation

let url = URL(fileURLWithPath: "video.mp4")
let bamf = try Bamf(url)
```

The initializer reads the file data and parses top-level atoms into ``Bamf/children``.

## Iterate through atoms

Walk the parsed tree by iterating top-level atoms and their children:

```swift
for atom in bamf.children {
  print("Type: \(atom.type)")

  for child in atom.displayChildren {
    print("  Child: \(child.type)")
  }
}
```

Use ``Atom/displayChildren`` when you want the most useful view of nested atoms, including types that expose child data through custom display logic.

## Find an atom recursively

Use ``Atom/findAtom(ofType:)`` to locate the first descendant atom matching a specific atom class:

```swift
if let moov = bamf.children.first(where: { $0 is Atom.MOOV }),
   let mdia = moov.findAtom(ofType: Atom.MDIA.self) {
  print("Found MDIA atom: \(mdia)")
}
```

This performs a depth-first search over ``Atom/displayChildren`` and returns the first matching descendant, or `nil` if none is found.

You can use the same approach for metadata payloads:

```swift
if let meta = bamf.children.first(where: { $0 is Atom.META }),
   let ilstData = meta.findAtom(ofType: Atom.ILSTData.self) {
  print("Metadata value: \(ilstData.value)")
}
```

## Parse raw data directly

If you already have ISOBMFF bytes in memory, parse the data without going through a file URL:

```swift
let fileData = try Data(contentsOf: url)
let atoms = try Bamf.parse(fileData)
```

This returns an array of parsed ``Atom`` values that you can traverse the same way as ``Bamf/children``.
