import Foundation

/// An ``Edit`` is the response from an ``Edits/Create`` call.
///
/// ## Related Calls
///
///- ``Edits/Create``
///
/// ## See Also
///
/// - [OpenAI API](https://beta.openai.com/docs/api-reference/edits)
/// - [Editing code guide](https://beta.openai.com/docs/guides/code/editing-code)
public struct Edit: JSONResponse, Equatable {
  /// The creation date.
  public let created: Date
  
  /// The list of choices.
  public let choices: [Choice]
  
  /// The token ``Usage`` from the request.
  public let usage: Usage
  
  /// Initializes an edit response.
  ///
  /// - Parameters:
  ///   - created: The creation date.
  ///   - choices: The choices generated.
  ///   - usage: The token usage from the request.
  public init(
    created: Date,
    choices: [Choice],
    usage: Usage
  ) {
    self.created = created
    self.choices = choices
    self.usage = usage
  }
}

extension Edit {
  /// A choice returned from an ``Edit`` request.
  public struct Choice: Equatable, Codable, CustomStringConvertible {
    /// The text of the generated choice.
    public let text: String
    
    /// The index of the choice (`0`-based).
    public let index: Int

    /// Initializes the choice.
    ///
    /// - Parameter text: The text of the generated choice.
    /// - Parameter index: The index of the choice.
    public init(text: String, index: Int) {
      self.text = text
      self.index = index
    }
    
    public var description: String { text }
  }
}
