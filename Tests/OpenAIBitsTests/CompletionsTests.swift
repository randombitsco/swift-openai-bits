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
      #"{"logit_bias":{},"model":"text-davinci-002","prompt":"Input string."}"#,
      try jsonEncode(value, options: [.sortedKeys])
    )
  }
  
  func testCompletionsFullRquestToJSON() throws {
    let value = Completions(
      model: "foo", prompt: "bar", suffix: "yada",
      maxTokens: 100, temperature: 0.5, topP: 0.6, n: 2, stream: true, logprobs: 3, echo: false,
      stop: ["stop"], presencePenalty: 0.7, frequencyPenalty: 0.8, bestOf: 4,
      logitBias: [5234: -100],
      user: "jblogs"
    )
    XCTAssertNoDifference(
      #"{"best_of":4,"echo":false,"frequency_penalty":0.8,"logit_bias":{"5234":-100},"logprobs":3,"max_tokens":100,"model":"foo","n":2,"presence_penalty":0.7,"prompt":"bar","stop":["stop"],"stream":true,"suffix":"yada","temperature":0.5,"top_p":0.6,"user":"jblogs"}"#,
      try jsonEncode(value, options: [.sortedKeys])
    )
  }
}
