import Foundation
import Testing

@testable import ISOBMFF

// Test compatibility with test files from ExifTool
@Suite struct AtomTests {
  @Test func mvhd() {
    // Data(base64Encoded: "", options: .ignoreUnknownCharacters)
    let data = Data(
      base64Encoded: """
        AAAAAOJ/aAjif2gIAAAD6AAACkQAAQAAAQAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAB
        AAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAw==",
        """,
      options: .ignoreUnknownCharacters
    )!

    let isoFormatter = ISO8601DateFormatter()

    let atom = Atom.MVHD(data: data)
    #expect(atom.version == 0)
    #expect(atom.flags == [0, 0, 0])
    #expect(isoFormatter.string(from: atom.creationTime) == "2024-05-31T11:42:00Z")
    #expect(isoFormatter.string(from: atom.modificationTime) == "2024-05-31T11:42:00Z")
    #expect(atom.timeScale == 1000)
    #expect(atom.duration == 2628)
    #expect(atom.preferredRate == 1.0)
    #expect(atom.preferredVolume == 0)
    // #expect(atom.nextTrackID == 0)
  }
}
