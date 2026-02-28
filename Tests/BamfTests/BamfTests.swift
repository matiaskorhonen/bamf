import Foundation
import Testing

@testable import Bamf

@Suite struct BamfTests {
  @Test func mpeg4() throws {
    let urls = Bundle.module.urls(forResourcesWithExtension: "mp4", subdirectory: "Fixtures")

    #expect(urls != nil, "there should be test MP4 files in the test bundle")
    #expect(urls!.count == 2)

    for url in urls! {
      let bamf = try Bamf(url as URL)
      #expect(bamf.children.count > 0)
    }
  }

  @Test func quicktime() throws {
    let urls = Bundle.module.urls(forResourcesWithExtension: "mov", subdirectory: "Fixtures")

    #expect(urls != nil, "there should be test MOV files in the test bundle")
    #expect(urls!.count == 1)

    for url in urls! {
      let bamf = try Bamf(url as URL)
      #expect(bamf.children.count > 0)
    }
  }

  @Test func findAtomFindsAtomByClass() throws {
    let urls = Bundle.module.urls(forResourcesWithExtension: "mp4", subdirectory: "Fixtures")

    #expect(urls != nil, "there should be test MP4 files in the test bundle")
    #expect(urls!.count > 0)

    for url in urls! {
      let bamf = try Bamf(url as URL)
      let ftyp = bamf.findAtom(ofType: Atom.FTYP.self)
      #expect(ftyp != nil)
    }
  }
}
