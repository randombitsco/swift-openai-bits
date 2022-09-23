import XCTest
import CustomDump
@testable import OpenAIBits

final class CompletionsTests: XCTestCase {

  func testCompletionsStringRequestToJSON() throws {
    let value = Completions(
      model: .text_davinci_002,
      prompt: "Input string."
    )
    XCTAssertNoDifference(
      #"{"model":"text-davinci-002","prompt":"Input string."}"#,
      try jsonEncode(value)
    )
  }
}
