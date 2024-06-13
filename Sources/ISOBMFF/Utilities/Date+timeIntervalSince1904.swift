import Foundation

extension Date {
  init(timeIntervalSince1904: TimeInterval) {
    // The difference between the Unix timestamp epoch (1970) and the Mac
    // timestamp epoch (1904) is 2,082,844,800 seconds
    self.init(timeIntervalSince1970: timeIntervalSince1904 - 2_082_844_800)
  }
}
