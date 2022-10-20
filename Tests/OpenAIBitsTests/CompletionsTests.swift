import XCTest
import CustomDump
@testable import OpenAIBits

final class CompletionsTests: XCTestCase {

  func testCompletionsStringRequestToJSON() throws {
    let value = Completions.Create(
      model: .text_davinci_002,
      prompt: "Input string."
    )
    XCTAssertNoDifference(
      #"{"logit_bias":{},"model":"text-davinci-002","prompt":"Input string."}"#,
      try jsonEncode(value, options: [.sortedKeys])
    )
  }
  
  func testCompletionsFullRquestToJSON() throws {
    let value = Completions.Create(
      model: "foo", prompt: "bar", suffix: "yada",
      maxTokens: 100, temperature: 0.5, topP: 0.6, n: 2, logprobs: 3, echo: false,
      stop: .init("four"), presencePenalty: 0.7, frequencyPenalty: 0.8, bestOf: 4,
      logitBias: [5234: -100],
      user: "jblogs"
    )
    XCTAssertNoDifference(
      #"{"best_of":4,"echo":false,"frequency_penalty":0.8,"logit_bias":{"5234":-100},"logprobs":3,"max_tokens":100,"model":"foo","n":2,"presence_penalty":0.7,"prompt":"bar","stop":["four"],"suffix":"yada","temperature":0.5,"top_p":0.6,"user":"jblogs"}"#,
      try jsonEncode(value, options: [.sortedKeys])
    )
  }
  
  func testCompletionsResponseFromJSON() throws {
    XCTAssertNoDifference(
      Completion(
        id: "a",
        created: .init(timeIntervalSince1970: .zero),
        model: "b",
        choices: [
          .init(
            text: "choice 1", index: 0,
            logprobs: .init(
              tokens: ["choice", " 1"],
              tokenLogprobs: [-1, -2],
              topLogprobs: [
                ["a": -1, "b": -2, "c": -3],
                ["d": -4, "e": -5, "f": -6],
              ],
              textOffset: [1, 7]
            ),
            finishReason: .length
          ),
          .init(
            text: "choice 2", index: 1,
            finishReason: .stop
          ),
        ],
        usage: .init(promptTokens: 1, completionTokens: 2, totalTokens: 3))
      ,
      try jsonDecode("""
      {
        "id": "a", "created": 0, "model": "b",
        "choices": [
          {
            "text": "choice 1",
            "index": 0,
            "logprobs": {
              "tokens": ["choice", " 1"],
              "token_logprobs": [-1, -2],
              "top_logprobs": [
                {"a": -1, "b": -2, "c": -3},
                {"d": -4, "e": -5, "f": -6}
              ],
              "text_offset": [1, 7]
            },
            "finish_reason": "length"
          },
          {"text": "choice 2", "index": 1, "finish_reason": "stop"}
        ],
        "usage": {"prompt_tokens": 1, "completion_tokens": 2, "total_tokens": 3}
      }
      """)
    )
  }
  
  func testCompletionsCreateStop() throws {
    typealias Stop = Completions.Stop
    
    XCTAssertEqual(["One"], Stop("One").value)
    XCTAssertEqual(["One", "Two"], Stop("One", "Two").value)
    XCTAssertEqual(["One", "Two", "Three"], Stop("One", "Two", "Three").value)
    XCTAssertEqual(["One", "Two", "Three", "Four"], Stop("One", "Two", "Three", "Four").value)
  }
  
  func testCompletionsCreateStopToJSON() throws {
    let value = Completions.Stop("One", "Two")
    try XCTAssertEqual(jsonEncode(value), """
    ["One","Two"]
    """)
  }
}
