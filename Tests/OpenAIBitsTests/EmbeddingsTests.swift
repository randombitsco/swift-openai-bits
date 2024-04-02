import XCTest
import CustomDump
@testable import OpenAIBits

final class EmbeddingsTests: XCTestCase {

  func testEmbeddingsStringRequestToJSON() throws {
    let value = Embeddings.Create(
      model: .text_davinci_003,
      input: "Input string."
    )
    XCTAssertNoDifference(
      #"{"input":"Input string.","model":"text-davinci-003"}"#,
      try jsonEncode(value, options: [.sortedKeys])
    )
  }
  
  func testEmbeddingsTokenArrayRequestToJSON() throws {
    let value = Embeddings.Create(
      model: .text_davinci_003,
      input: [12,34,567]
    )
    XCTAssertNoDifference(
      #"{"input":[12,34,567],"model":"text-davinci-003"}"#,
      try jsonEncode(value, options: [.sortedKeys])
    )
  }
  
  func testEmbeddingsWithUserRequestToJSON() throws {
    let value = Embeddings.Create(
      model: .text_davinci_003,
      input: "Input string.",
      user: "foo"
    )
    XCTAssertNoDifference(
      #"{"input":"Input string.","model":"text-davinci-003","user":"foo"}"#,
      try jsonEncode(value, options: [.sortedKeys])
    )
  }
}
