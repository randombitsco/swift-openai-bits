import XCTest
import CustomDump
@testable import OpenAIBits

final class ChatCompletionsTests: XCTestCase {

  func testCompletionsStringRequestToJSON() throws {
    let value = Chat.Completions(
      model: .gpt_3_5_turbo,
      messages: [
        .init(role: .user, content: "Input string.")
      ]
    )
    XCTAssertNoDifference(
      #"{"logit_bias":{},"messages":[{"content":"Input string.","role":"user"}],"model":"gpt-3.5-turbo"}"#,
      try jsonEncode(value, options: [.sortedKeys])
    )
  }
  
  func testCompletionsFullRquestToJSON() throws {
    let value = Chat.Completions(
      model: .gpt_3_5_snapshot("0301"),
      messages: .from(user: "Content."),
      maxTokens: 100, temperature: 0.5, topP: 0.6, n: 2,
      stop: "four", presencePenalty: 0.7, frequencyPenalty: 0.8,
      logitBias: [5234: -100],
      user: "jblogs"
    )
    XCTAssertNoDifference(
      #"{"frequency_penalty":0.8,"logit_bias":{"5234":-100},"max_tokens":100,"messages":[{"content":"Content.","role":"user"}],"model":"gpt-3.5-turbo-0301","n":2,"presence_penalty":0.7,"stop":["four"],"temperature":0.5,"top_p":0.6,"user":"jblogs"}"#,
      try jsonEncode(value, options: [.sortedKeys])
    )
  }
  
  func testCompletionsResponseFromJSON() throws {
    XCTAssertNoDifference(
      ChatCompletion(
        id: "a",
        created: .init(timeIntervalSince1970: .zero),
        model: .gpt_3_5_turbo,
        choices: [
          .init(
            message: .init(role: .assistant, content: "choice 1"),
            index: 0, finishReason: .length
          ),
          .init(
            message: .init(role: .assistant, content: "choice 2"),
            index: 1, finishReason: .stop
          ),
        ],
        usage: .init(promptTokens: 1, completionTokens: 2, totalTokens: 3))
      ,
      try jsonDecode("""
      {
        "id": "a", "created": 0, "model": "gpt-3.5-turbo",
        "choices": [
          {
            "message": {"role": "assistant", "content": "choice 1"},
            "index": 0,
            "finish_reason": "length"
          },
          {
            "message": {"role": "assistant", "content": "choice 2"},
            "index": 1,
            "finish_reason": "stop"
          }
        ],
        "usage": {"prompt_tokens": 1, "completion_tokens": 2, "total_tokens": 3}
      }
      """)
    )
  }
  
  func testCompletionsCreateStop() throws {
    XCTAssertEqual(["One"], Stop("One").value)
    XCTAssertEqual(["One", "Two"], Stop("One", "Two").value)
    XCTAssertEqual(["One", "Two", "Three"], Stop("One", "Two", "Three").value)
    XCTAssertEqual(["One", "Two", "Three", "Four"], Stop("One", "Two", "Three", "Four").value)
  }
  
  func testCompletionsCreateStopToJSON() throws {
    let value = Stop("One", "Two")
    try XCTAssertEqual(jsonEncode(value), """
    ["One","Two"]
    """)
  }
}
