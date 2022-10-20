import Foundation

/// Response from a ``Completions/Create`` request.
public struct Completion: Identified, JSONResponse, Equatable {
  /// The unique identifier for a ``Completion``.
  public struct ID: Identifier {
    public let value: String

    public init(_ value: String) {
      self.value = value
    }
  }

  /// The unique `ID` of the ``Completion``.
  public let id: ID
  
  /// The creation `Date`.
  public let created: Date
  
  /// The `Model.ID` the completion was generated by.
  public let model: Model.ID
  
  /// The list of ``Choice`` options generated.
  public let choices: [Choice]
  
  /// The token ``Usage`` stats for the generation.
  public let usage: Usage
  
  /// Constructs a ``Completion`` result.
  ///
  /// - Parameters:
  ///   - id: The unique `ID`
  ///   - created: The creation `Date`.
  ///   - model: The `Model.ID` the completion was generated by.
  ///   - choices: The list of ``Choice`` options generated.
  ///   - usage: The token ``Usage`` stats for the generation.
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
    
    /// Which completion number (`0`-based).
    public let index: Int
    
    /// The list of `logprobs`, if present.
    public let logprobs: Logprobs?
    
    /// The reason for finishing.
    public let finishReason: String
    
    /// Creates a ``Completion/Choice``.
    ///
    /// - Parameters:
    ///   - text: The text of the completion.
    ///   - index: Which completion number (`0`-based).
    ///   - logprobs: The list of `logprobs`, if present.
    ///   - finishReason: The reason for finishing.
    public init(
      text: String,
      index: Int,
      logprobs: Logprobs? = nil,
      finishReason: String
    ) {
      self.text = text
      self.index = index
      self.logprobs = logprobs
      self.finishReason = finishReason
    }
  }
}
