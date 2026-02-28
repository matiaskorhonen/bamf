import Testing

@testable import BamfCLI

@Suite struct ANSIColorsTests {
  @Test func ansiDisabledReturnsOriginalString() {
    #expect(ansi("hello", ANSI.cyan, enabled: false) == "hello")
  }

  @Test func ansiEnabledWrapsSingleCode() {
    #expect(ansi("hello", ANSI.cyan, enabled: true) == "\u{001B}[36mhello\u{001B}[0m")
  }

  @Test func ansiEnabledWrapsMultipleCodes() {
    #expect(
      ansi("hello", ANSI.bold, ANSI.cyan, enabled: true)
        == "\u{001B}[1m\u{001B}[36mhello\u{001B}[0m"
    )
  }

  @Test func ansiEmptyStringRemainsEmpty() {
    #expect(ansi("", ANSI.yellow, enabled: true) == "\u{001B}[33m\u{001B}[0m")
    #expect(ansi("", ANSI.yellow, enabled: false) == "")
  }
}
