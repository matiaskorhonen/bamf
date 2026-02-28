import Foundation
import Testing

@testable import Bamf

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
    #expect(atom.preferredVolume == 1.0)
    #expect(atom.nextTrackID == 3)
  }

  // Data extracted from DJI_0007.MP4
  @Test func tkhd() {
    let data = Data(
      base64Encoded:
        "AAAAD+J/aAjif2gIAAAAAQAAAAAAAPZXAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAQAAAAA8AAAAIcAAA",
      options: .ignoreUnknownCharacters
    )!

    let isoFormatter = ISO8601DateFormatter()
    let atom = Atom.TKHD(data: data)
    #expect(atom.version == 0)
    #expect(atom.flags == [0, 0, 15])
    #expect(isoFormatter.string(from: atom.creationTime) == "2024-05-31T11:42:00Z")
    #expect(isoFormatter.string(from: atom.modificationTime) == "2024-05-31T11:42:00Z")
    #expect(atom.trackID == 1)
    #expect(atom.duration == 63063)
    #expect(atom.layer == 0)
    #expect(atom.alternateGroup == 0)
    #expect(atom.volume == 0)
    #expect(atom.width == 3840)
    #expect(atom.height == 2160)
  }

  // Data extracted from DJI_0007.MP4
  @Test func mdhd() {
    let data = Data(
      base64Encoded: "AAAAAOJ/aAjif2gIAABdwAAA9lcAAAAA",
      options: .ignoreUnknownCharacters
    )!

    let isoFormatter = ISO8601DateFormatter()
    let atom = Atom.MDHD(data: data)
    #expect(atom.version == 0)
    #expect(atom.flags == [0, 0, 0])
    #expect(isoFormatter.string(from: atom.creationTime) == "2024-05-31T11:42:00Z")
    #expect(isoFormatter.string(from: atom.modificationTime) == "2024-05-31T11:42:00Z")
    #expect(atom.timeScale == 24000)
    #expect(atom.duration == 63063)
  }

  // Data extracted from DJI_0007.MP4
  @Test func hdlr() {
    let data = Data(
      base64Encoded: "AAAAAG1obHJ2aWRlAAAAAAAAAAAAAAAAEERKSS5BVkMAAAAAAAAAAAA=",
      options: .ignoreUnknownCharacters
    )!

    let atom = Atom.HDLR(data: data)
    #expect(atom.version == 0)
    #expect(atom.flags == [0, 0, 0])
    #expect(atom.handlerType == "vide")
    // QuickTime Pascal strings are decoded without the leading length byte
    #expect(atom.name == "DJI.AVC")
  }

  // Data extracted from DJI_0007.MP4
  @Test func ftyp() {
    let data = Data(
      base64Encoded: "YXZjMSAUAgBhdmMxaXNvbQAAAAA=",
      options: .ignoreUnknownCharacters
    )!

    let atom = Atom.FTYP(data: data)
    #expect(atom.majorBrand == "avc1")
    #expect(atom.minorVersion == "2014.2.0")
    #expect(atom.compatibleBrands == ["avc1", "isom"])
  }

  // Data extracted from DJI_0007.MP4
  @Test func vmhd() {
    let data = Data(
      base64Encoded: "AAAAAQAAAAAAAAAA",
      options: .ignoreUnknownCharacters
    )!

    let atom = Atom.VMHD(data: data)
    #expect(atom.version == 0)
    #expect(atom.flags == [0, 0, 1])
    #expect(atom.graphicsMode == 0)
    #expect(atom.opcolor == [0, 0, 0])
  }

  // Data extracted from DJI_0007.MP4
  @Test func stts() {
    let data = Data(
      base64Encoded: "AAAAAAAAAAEAAAA/AAAD6Q==",
      options: .ignoreUnknownCharacters
    )!

    let atom = Atom.STTS(data: data)
    #expect(atom.version == 0)
    #expect(atom.flags == [0, 0, 0])
    #expect(atom.entryCount == 1)
    let entries = atom.entries
    #expect(entries.count == 1)
    #expect(entries[0].sampleCount == 63)
    #expect(entries[0].sampleDelta == 1001)
  }

  // Data extracted from DJI_0007.MP4
  @Test func stss() {
    let data = Data(
      base64Encoded: "AAAAAAAAAAMAAAABAAAAHwAAAD0=",
      options: .ignoreUnknownCharacters
    )!

    let atom = Atom.STSS(data: data)
    #expect(atom.version == 0)
    #expect(atom.flags == [0, 0, 0])
    #expect(atom.entryCount == 3)
    let numbers = atom.sampleNumbers
    #expect(numbers.count == 3)
    #expect(numbers[0] == 1)
    #expect(numbers[1] == 31)
    #expect(numbers[2] == 61)
  }

  // Data extracted from DJI_0007.MP4
  @Test func stsc() {
    let data = Data(
      base64Encoded: "AAAAAAAAAAEAAAABAAAAAQAAAAE=",
      options: .ignoreUnknownCharacters
    )!

    let atom = Atom.STSC(data: data)
    #expect(atom.version == 0)
    #expect(atom.flags == [0, 0, 0])
    #expect(atom.entryCount == 1)
    let entries = atom.entries
    #expect(entries.count == 1)
    #expect(entries[0].firstChunk == 1)
    #expect(entries[0].samplesPerChunk == 1)
    #expect(entries[0].sampleDescriptionIndex == 1)
  }

  // Data extracted from DJI_0007.MP4
  @Test func stsz() {
    let data = Data(
      base64Encoded:
        "AAAAAAAAAAAAAAA/ACWw2QAbGb0ADebyAACc/gAAzgUAAWDwAAI3SgAC2wIAA6rrAAQ04AAFdb4ABeAgAAboHAAG2rkAB53JAAhRyAAJSEgACVk+AAiRZAAIISoACC7YAAgxDAAIN/oAB3FRAAelfwAHqoMAByNdAAdqHAAGu8EABxDtABHP5QAG17IAB05YAAbyiQAG7koABs4GAAdfdwAHTnYAB1rWAAdZYQAHVVcAB0UdAAdFmwAHWCMAB07+AAdfzwAHRjYAB1MKAAc5QAAHQSgABymrAAceJgAG+5EABwL4AAdFGgAH/YYACB7LAAg99QAITBMAB568ABKKxgAIf5UAB7Jw",
      options: .ignoreUnknownCharacters
    )!

    let atom = Atom.STSZ(data: data)
    #expect(atom.version == 0)
    #expect(atom.flags == [0, 0, 0])
    #expect(atom.sampleSize == 0)
    #expect(atom.sampleCount == 63)
    let sizes = atom.entrySizes
    #expect(sizes.count == 63)
  }

  // Data extracted from DJI_0007.MP4
  @Test func stco() {
    let data = Data(
      base64Encoded:
        "AAAAAAAAAD8AAT6vACbviABCCUUAT/A3AFCNNQBRWzoAUrwqAFTzdABXznYAW3lhAF+uQQBlI/8AawQfAHHsOwB4xvQAgGS9AIi2hQCR/s0Am1gLAKPpbwCsCpkAtDlxALxqfQDEpHEAzBXCANO7QQDbZcQA4okhAOnzPQDwrv4A97/rAQmP0AEQZ4IBF7XaAR6oYwEllq0BLGSzATPEKgE7EqABQm12AUnG1wFRHC4BWGFLAV+m5gFm/wkBbk4HAXWt1gF89gYBhEkQAYuCUAGSw3gBme0jAaELSQGoBtoBrwnSAbZO7AG+THIBxms9Ac6pMgHW9UUB3pQBAfEexwH5nlw=",
      options: .ignoreUnknownCharacters
    )!

    let atom = Atom.STCO(data: data)
    #expect(atom.version == 0)
    #expect(atom.flags == [0, 0, 0])
    #expect(atom.entryCount == 63)
    let offsets = atom.chunkOffsets
    #expect(offsets.count == 63)
    #expect(offsets[0] == 81583)
  }
}

