// MARK: - ANSI Colors

enum ANSI {
  static let reset = "\u{001B}[0m"
  static let bold = "\u{001B}[1m"
  static let dim = "\u{001B}[2m"
  static let cyan = "\u{001B}[36m"
  static let yellow = "\u{001B}[33m"
}

func ansi(_ string: String, _ codes: String..., enabled: Bool) -> String {
  guard enabled else { return string }
  return codes.joined() + string + ANSI.reset
}
