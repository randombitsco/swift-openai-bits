import Foundation

// MARK: Edits

extension Text {
  /// A ``Call`` that creates a new ``Edit`` for the provided ``input``, ``instruction``, and other parameters.
  ///
  /// ## Examples
  ///
  /// ### A simple edit
  ///
  /// ```swift
  /// let client = OpenAI(apiKey: "...")
  /// let edit = try await client.call(Text.Edits(
  ///   model: .davinci,
  ///   input: "The quick brown fox jumps over the lazy dog."
  ///   instruction: "Change the dog to a cat."
  /// ))
  /// ```
  ///
  /// ## See Also
  ///
  /// - [OpenAI API](https://platform.openai.com/docs/api-reference/edits/create)
  /// - [Editing code guide](https://platform.openai.com/docs/guides/code/editing-code)
  public struct Edits: JSONPostCall {
    /// Response with an ``Edit``.
    public typealias Response = Edit
    
    /// The path to the call.
    var path: String { "edits" }
    
    /// `ID` of the ``Model`` to use. You can use ``Models/List`` to see all of your available models, or see our [Model overview](https://platform.openai.com/docs/models/overview) for descriptions of them.
    public let model: Model.ID
    
    /// The input text to use as a starting point for the edit.
    public let input: String?
    
    /// The instruction that tells the model how to edit the prompt.
    public let instruction: String
    
    /// The number of ``Edit/Choice`` values to return. (defaults to `1`)
    public let n: Int?
    
    /// What sampling temperature to use. Higher values means tzhe model will take more risks. Try `0.9` for more creative applications, and `0` (argmax sampling) for ones with a well-defined answer.
    ///
    /// We generally recommend altering this or ``topP`` but not both.
    public let temperature: Percentage?
    
    /// An alternative to sampling with temperature, called nucleus sampling, where the model considers the results of the tokens with top_p probability mass. So `0.1` means only the tokens comprising the top 10% probability mass are considered.
    ///
    /// We generally recommend altering this or ``temperature`` but not both.
    public let topP: Percentage?
    
    /// Creates a new ``Edit`` creation call.
    ///
    /// - Parameters:
    ///   - model: ID of the model to use. You can use ``Models/List`` to see all of your available models, or see our [Model overview](https://platform.openai.com/docs/models/overview) for descriptions of them.
    ///   - input: The input text to use as a starting point for the edit.
    ///   - instruction: The instruction that tells the model how to edit the prompt.
    ///   - n: The number of ``Edit/Choice`` values to return. (defaults to `1`)
    ///   - temperature: What sampling temperature to use. Higher values means tzhe model will take more risks. Try `0.9` for more creative applications, and `0` (argmax sampling) for ones with a well-defined answer.
    ///   - topP: An alternative to sampling with temperature, called nucleus sampling, where the model considers the results of the tokens with top_p probability mass. So `0.1` means only the tokens comprising the top 10% probability mass are considered.
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
