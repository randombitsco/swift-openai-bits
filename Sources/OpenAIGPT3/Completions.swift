import Foundation

/// A namespace for completions-related types.
public enum Completions {}

extension Completions {
  /// Represents a request for completions on a ``Prompt``
  public struct Request: Equatable, Codable {
    public let model: Model.ID
    public let prompt: Prompt?
    public let suffix: String?
    public let maxTokens: Int?
    public let temperature: Percentage?
    public let topP: Percentage?
    public let n: Percentage?
    public let stream: Bool?
    public let logprobs: Int?
    public let echo: Bool?
    public let stop: [String]?
    public let presencePenalty: Penalty?
    public let frequencyPenalty: Penalty?
    public let bestOf: Percentage?
    public let logitBias: [Token: Double]?
    public let user: String?
  }
}

extension Completions {
  /// Represents a response from a completion request.
  ///
  /// Example:
  ///
  /// ```json
  /// {
  ///   "id": "cmpl-uqkvlQyYK7bGYrRHQ0eXlWi7",
  ///   "object": "text_completion",
  ///   "created": 1589478378,
  ///   "model": "text-davinci-002",
  ///   "choices": [
  ///     {
  ///       "text": "\n\nThis is a test",
  ///       "index": 0,
  ///       "logprobs": null,
  ///       "finish_reason": "length"
  ///     }
  ///   ],
  ///   "usage": {
  ///     "prompt_tokens": 5,
  ///     "completion_tokens": 6,
  ///     "total_tokens": 11
  ///   }
  /// }
  /// ```
  public struct Response: Equatable, Codable {
    public struct ID: Identifier {
      public let value: String
      
      public init(value: String) {
        self.value = value
      }
    }
    
    public let id: ID
    public let created: Date
    public let model: Model.ID
    public let choices: [Choice]
    public let usage: Usage
  }

  /// One of the completion choices.
  public struct Choice: Equatable, Codable {
    /// The text of the completion.
    public let text: String
    
    /// Which completion number.
    public let index: Int
    
    /// The list of `logprobs`.
    public let logprobs: [String]
    
    /// The reason for finishing.
    public let finishReason: String
  }
}
