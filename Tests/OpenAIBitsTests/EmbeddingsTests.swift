import XCTest
import CustomDump
@testable import OpenAIBits

final class EmbeddingsTests: XCTestCase {

  func testEmbeddingsStringRequestToJSON() throws {
    let value = Embeddings.Create(
      model: .text_davinci_002,
      input: "Input string."
    )
    XCTAssertNoDifference(
      #"{"model":"text-davinci-002","input":"Input string."}"#,
      try jsonEncode(value)
    )
  }
  
  func testEmbeddingsTokenArrayRequestToJSON() throws {
    let value = Embeddings.Create(
      model: .text_davinci_002,
      input: [12,34,567]
    )
    XCTAssertNoDifference(
      #"{"model":"text-davinci-002","input":[12,34,567]}"#,
      try jsonEncode(value)
    )
  }
  
  func testEmbeddingsWithUserRequestToJSON() throws {
    let value = Embeddings.Create(
      model: .text_davinci_002,
      input: "Input string.",
      user: "foo"
    )
    XCTAssertNoDifference(
      #"{"model":"text-davinci-002","input":"Input string.","user":"foo"}"#,
      try jsonEncode(value)
    )
  }
}
