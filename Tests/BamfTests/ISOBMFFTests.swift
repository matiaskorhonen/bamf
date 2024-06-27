import Foundation
import Testing

@testable import Bamf

@Suite struct BamfTests {
  @Test func mpeg4() {
    let urls = Bundle.module.urls(forResourcesWithExtension: "MP4", subdirectory: nil)

    #expect(urls != nil, "there should be test MP4 files in the test bundle")
    #expect(urls!.count == 4)

    for url in urls! {
      let bamf = Bamf(url)
      #expect(Bamf.children.count > 0)
    }
  }

  @Test func quicktime() {
    let urls = Bundle.module.urls(forResourcesWithExtension: "MOV", subdirectory: nil)

    #expect(urls != nil, "there should be test MOV files in the test bundle")
    #expect(urls!.count == 1)

    for url in urls! {
      let bamf = Bamf(url)
      #expect(Bamf.children.count > 0)
    }
  }
}
