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

  @Test func ilstData() {
    // type=1 (UTF-8), locale=0, value="hello"
    let data = Data([0, 0, 0, 1, 0, 0, 0, 0, 104, 101, 108, 108, 111])

    let atom = Atom.ILSTData(data: data)
    #expect(atom.dataType == 1)
    #expect(atom.locale == 0)
    #expect(atom.value == "hello")
  }

  @Test func ilst() {
    // Build a minimal ilst body: one .cmt item containing one data sub-atom
    // data atom: size=21, type="data", dataType=1, locale=0, "hello"
    let dataAtomBytes: [UInt8] = [
      0, 0, 0, 21,  // size = 21
      100, 97, 116, 97,  // type = "data"
      0, 0, 0, 1,  // dataType = 1 (UTF-8)
      0, 0, 0, 0,  // locale = 0
      104, 101, 108, 108, 111,  // "hello"
    ]
    // .cmt item: size=29, type=".cmt", then the data atom
    var cmtBytes: [UInt8] = [
      0, 0, 0, 29,  // size = 29
      46, 99, 109, 116,  // type = ".cmt"
    ]
    cmtBytes.append(contentsOf: dataAtomBytes)

    let atom = Atom.ILST(data: Data(cmtBytes))
    #expect(atom.children.count == 1)
    #expect(atom.children[0].type == ".cmt")
    #expect(atom.children[0].children.count == 1)
    let dataAtom = atom.children[0].children[0] as? Atom.ILSTData
    #expect(dataAtom != nil)
    #expect(dataAtom?.dataType == 1)
    #expect(dataAtom?.locale == 0)
    #expect(dataAtom?.value == "hello")
  }

  @Test func meta() {
    // hdlr atom: size=33, type="hdlr", version+flags=0, pre_defined=0,
    //            handler_type="mdir", reserved=0×12, name="" (null byte)
    let hdlrBytes: [UInt8] = [
      0, 0, 0, 33,  // size = 33
      104, 100, 108, 114,  // type = "hdlr"
      0, 0, 0, 0,  // version + flags
      0, 0, 0, 0,  // pre_defined
      109, 100, 105, 114,  // handler_type = "mdir"
      0, 0, 0, 0,  // reserved[0]
      0, 0, 0, 0,  // reserved[1]
      0, 0, 0, 0,  // reserved[2]
      0,  // name = "" (null terminator)
    ]
    // ilst atom: size=8 (empty), type="ilst"
    let ilstBytes: [UInt8] = [
      0, 0, 0, 8,  // size = 8
      105, 108, 115, 116,  // type = "ilst"
    ]
    // meta data: version+flags (4 bytes) + hdlr atom + ilst atom
    var metaData: [UInt8] = [0, 0, 0, 0]
    metaData.append(contentsOf: hdlrBytes)
    metaData.append(contentsOf: ilstBytes)

    let atom = Atom.META(data: Data(metaData))
    #expect(atom.children.count == 2)
    #expect(atom.children[0] is Atom.HDLR)
    #expect(atom.children[1] is Atom.ILST)
    let hdlr = atom.children[0] as? Atom.HDLR
    #expect(hdlr?.handlerType == "mdir")
  }

  @Test func parseSizeZeroAtomExtendsToEOF() throws {
    // one atom with size=0 should consume the rest of the stream
    let bytes: [UInt8] = [
      0, 0, 0, 0,  // size = 0 (extends to EOF)
      102, 114, 101, 101,  // type = "free"
      1, 2, 3, 4, 5,
    ]

    let atoms = try Bamf.parse(Data(bytes))
    #expect(atoms.count == 1)
    #expect(atoms[0].type == "free")
    #expect(atoms[0].data == Data([1, 2, 3, 4, 5]))
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
