import Foundation

/// Represents  [Edits](https://beta.openai.com/docs/api-reference/edits) requests to the OpenAI API.
///
/// Given a prompt and an instruction, the model will return an edited version of the prompt.
///
/// The primary request is the ``Edits/Create`` call, which takes an `input` string and an `instruction`, and returns an ``Edit`` value with a list of choices for the edited input.
public enum Edits {}

extension Edits {
  /// Send to the API via ``Client/call(_:)`` to create a new ``Edit`` for the provided `input`, `instruction`, and parameters.
  ///
  /// For example:
  ///
  /// ```swift
  /// let client = Client(apiKey: "...")
  /// let edit = try await client.call(Edits.Create(
  ///   model: .davinci
  /// ))
  /// ```
  public struct Create: JSONPostCall {
    /// Response with an ``Edit``.
    public typealias Response = Edit
    
    var path: String { "edits" }
    
    /// The model's ID.
    public let model: Model.ID
    
    /// The input string to be edited.
    public let input: String?
    
    /// The instruction for how to edit it.
    public let instruction: String
    
    /// The number of choices to return (defaults to `1`)
    public let n: Int?
    
    /// What sampling temperature to use. Higher values means the model will take more risks. Try 0.9 for more creative applications, and 0 (argmax sampling) for ones with a well-defined answer.
    public let temperature: Percentage?
    
    /// An alternative to sampling with temperature, called nucleus sampling, where the model considers the results of the tokens with top_p probability mass. So 0.1 means only the tokens comprising the top 10% probability mass are considered.
    public let topP: Percentage?
    
    /// Creates a new ``Edit`` creation call.
    ///
    /// - Parameters:
    ///   - model: ID of the model to use. You can use the List models API to see all of your available models, or see our Model overview for descriptions of them.
    ///   - input: The input text to use as a starting point for the edit.
    ///   - instruction: The instruction that tells the model how to edit the prompt.
    ///   - n: The number of ``Edit/Choice`` values to return.
    ///   - temperature: What sampling temperature to use. Higher values means the model will take more risks. Try 0.9 for more creative applications, and 0 (argmax sampling) for ones with a well-defined answer.
    ///   - topP: An alternative to sampling with temperature, called nucleus sampling, where the model considers the results of the tokens with top_p probability mass. So 0.1 means only the tokens comprising the top 10% probability mass are considered.
    ///
    /// - Note: We generally recommend altering `temperature` or `topP` but not both.
    public init(
      model: Model.ID,
      input: String? = nil,
      instruction: String,
      n: Int? = nil,
      temperature: Percentage? = nil,
      topP: Percentage? = nil
    ) {
      self.model = model
      self.input = input
      self.instruction = instruction
      self.n = n
      self.temperature = temperature
      self.topP = topP
    }
  }
}
