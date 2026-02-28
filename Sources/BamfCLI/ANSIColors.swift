// MARK: - ANSI Colors

/// ANSI escape code constants for terminal text formatting.
enum ANSI {
  /// Resets all formatting to the terminal default.
  static let reset = "\u{001B}[0m"
  /// Bold text.
  static let bold = "\u{001B}[1m"
  /// Dim (faint) text.
  static let dim = "\u{001B}[2m"
  /// Cyan text colour.
  static let cyan = "\u{001B}[36m"
  /// Yellow text colour.
  static let yellow = "\u{001B}[33m"
}

/// Wraps `string` in the given ANSI `codes` (and a reset suffix) when `enabled` is `true`.
///
/// - Parameters:
///   - string: The string to format.
///   - codes: One or more ANSI escape codes to prepend.
///   - enabled: When `false` the string is returned unmodified.
/// - Returns: The formatted (or unmodified) string.
func ansi(_ string: String, _ codes: String..., enabled: Bool) -> String {
  guard enabled else { return string }
  return codes.joined() + string + ANSI.reset
}
