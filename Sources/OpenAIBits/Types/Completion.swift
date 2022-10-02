import Foundation

/// Response from a `completions` request.
public struct Completion: JSONResponse, Equatable {
  public struct ID: Identifier {
    public let value: String

    public init(_ value: String) {
      self.value = value
    }
  }

  public let id: ID
  public let created: Date
  public let model: Model.ID
  public let choices: [Choice]
  public let usage: Usage

  public init(
    id: ID,
    created: Date,
    model: Model.ID,
    choices: [Choice],
    usage: Usage
  ) {
    self.id = id
    self.created = created
    self.model = model
    self.choices = choices
    self.usage = usage
  }
}

extension Completion {
  /// One of the completion choices.
  public struct Choice: Equatable, Codable {
    /// The text of the completion.
    public let text: String
    
    /// Which completion number.
    public let index: Int
    
    /// The list of `logprobs`.
    public let logprobs: [String]?
    
    /// The reason for finishing.
    public let finishReason: String
    
    public init(
      text: String,
      index: Int,
      logprobs: [String]? = nil,
      finishReason: String
    ) {
      self.text = text
      self.index = index
      self.logprobs = logprobs
      self.finishReason = finishReason
    }
  }
}
