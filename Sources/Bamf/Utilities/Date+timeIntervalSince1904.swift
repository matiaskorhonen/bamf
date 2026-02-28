import Foundation

extension Date {
  /// Creates a `Date` from a Mac epoch timestamp (seconds since 1904-01-01 00:00:00 UTC).
  ///
  /// - Parameter timeIntervalSince1904: Seconds elapsed since January 1, 1904 (the QuickTime/MP4 epoch).
  init(timeIntervalSince1904: TimeInterval) {
    // The difference between the Unix timestamp epoch (1970) and the Mac
    // timestamp epoch (1904) is 2,082,844,800 seconds
    self.init(timeIntervalSince1970: timeIntervalSince1904 - 2_082_844_800)
  }
}
