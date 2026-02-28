import Foundation
import Testing

@testable import Bamf

// Test compatibility with test files from ExifTool
@Suite struct ExifToolTests {
  @Test func jpeg2000() throws {
    let urls = Bundle.module.urls(forResourcesWithExtension: "jp2", subdirectory: "Fixtures/ExifTool")

    #expect(urls != nil, "there should be test JPEG2000 files in the test bundle")
    #expect(urls!.count == 1)

    for url in urls! {
      let bamf = try Bamf(url as URL)
      #expect(bamf.children.count > 0)
    }
  }

  @Test func m4a() throws {
    let urls = Bundle.module.urls(forResourcesWithExtension: "m4a", subdirectory: "Fixtures/ExifTool")

    #expect(urls != nil, "there should be test JPEG2000 files in the test bundle")
    #expect(urls!.count == 1)

    for url in urls! {
      let bamf = try Bamf(url as URL)
      #expect(bamf.children.count > 0)
    }
  }

  @Test func heic() throws {
    let urls = Bundle.module.urls(forResourcesWithExtension: "heic", subdirectory: "Fixtures/ExifTool")

    #expect(urls != nil, "there should be test HEIC files in the test bundle")
    #expect(urls!.count == 1)

    for url in urls! {
      let bamf = try Bamf(url as URL)
      #expect(bamf.children.count > 0)
    }
  }

  @Test func quicktime() throws {
    let urls = Bundle.module.urls(forResourcesWithExtension: "mov", subdirectory: "Fixtures/ExifTool")

    #expect(urls != nil, "there should be test MOV files in the test bundle")
    #expect(urls!.count == 1)

    for url in urls! {
      let bamf = try Bamf(url as URL)
      #expect(bamf.children.count > 0)
    }
  }
}
