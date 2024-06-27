import Foundation
import Testing

@testable import Bamf

// Test compatibility with test files from ExifTool
@Suite struct ExifToolTests {
  @Test func jpeg2000() {
    let urls = Bundle.module.urls(forResourcesWithExtension: "jp2", subdirectory: "ExifTool")

    #expect(urls != nil, "there should be test JPEG2000 files in the test bundle")
    #expect(urls!.count == 1)

    for url in urls! {
      let bamf = Bamf(url)
      #expect(Bamf.children.count > 0)
    }
  }

  @Test func m4a() {
    let urls = Bundle.module.urls(forResourcesWithExtension: "m4a", subdirectory: "ExifTool")

    #expect(urls != nil, "there should be test JPEG2000 files in the test bundle")
    #expect(urls!.count == 1)

    for url in urls! {
      let bamf = Bamf(url)
      #expect(Bamf.children.count > 0)
    }
  }

  @Test func heic() {
    let urls = Bundle.module.urls(forResourcesWithExtension: "heic", subdirectory: "ExifTool")

    #expect(urls != nil, "there should be test HEIC files in the test bundle")
    #expect(urls!.count == 1)

    for url in urls! {
      let bamf = Bamf(url)
      #expect(Bamf.children.count > 0)
    }
  }

  @Test func quicktime() {
    let urls = Bundle.module.urls(forResourcesWithExtension: "mov", subdirectory: "ExifTool")

    #expect(urls != nil, "there should be test MOV files in the test bundle")
    #expect(urls!.count == 1)

    for url in urls! {
      let bamf = Bamf(url)
      #expect(Bamf.children.count > 0)
    }
  }
}
