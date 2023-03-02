import Foundation

/// Response from a ``Chat/Completions`` request.
///
/// ## Related Calls
///
/// - ``Chat/Completions``
///
/// ## See Also
///
/// - [OpenAI API](https://platform.openai.com/docs/api-reference/chat)
/// - [Chat Guide](https://platform.openai.com/docs/guides/chat/chat-completions-beta)
public struct ChatCompletion: Identifiable, JSONResponse, Equatable {
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
  public let model: ChatModel
  
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
    model: ChatModel,
    choices: [Choice],
    usage: Usage
  ) {
    self.id = id
    self.created = created
    self.model = model
    self.choices = choices
    self.usage = usage
  }
  
  /// A convenience accessor for the `text` value for the first ``Choice``.
  public var message: ChatMessage {
    choices[0].message
  }
  
  /// A convenience accessor for the ``FinishReason`` for the first ``Choice``.
  public var finishReason: FinishReason {
    choices[0].finishReason
  }
}

// MARK: Completion.Choice

extension ChatCompletion {
  /// One of the ``Completion`` choices.
  public struct Choice: Equatable, Codable {
    /// The ``ChatMessage`` of the completion.
    public let message: ChatMessage
    
    /// Which completion number (`0`-based).
    public let index: Int
    
    /// The reason for finishing.
    public let finishReason: FinishReason
    
    /// Creates a ``Completion/Choice``.
    ///
    /// - Parameters:
    ///   - message: ``ChatMessage``
    ///   - index: Which completion number (`0`-based).
    ///   - finishReason: The reason for finishing.
    public init(
      message: ChatMessage,
      index: Int,
      finishReason: FinishReason
    ) {
      self.message = message
      self.index = index
      self.finishReason = finishReason
    }
  }
}
