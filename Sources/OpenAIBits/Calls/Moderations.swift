import Foundation

/// Given a input text, outputs if the model classifies it as violating OpenAI's content policy.
///
/// ## Calls
///
/// - ``Moderations/Create`` - Creates a ``Moderation`` assessment.
///
/// ## See Also
///
/// - [OpenAI API](https://beta.openai.com/docs/api-reference/moderations)
/// - [Moderations Guide](https://beta.openai.com/docs/guides/moderation)
public enum Moderations {}

// MARK: Create

extension Moderations {
  
  /// Classifies if text violates OpenAI's Content Policy.
  ///
  /// ## Examples
  ///
  /// A simple call with the `.latest` model:
  ///
  /// ```swift
  /// let client = Client(apiKey: ...)
  /// let moderation = try await client.call(Moderations.Create(
  ///   input: "This is innocuous text."
  /// ))
  /// ```
  ///
  /// ## See Also
  ///
  /// - [OpenAI API](https://beta.openai.com/docs/api-reference/moderations/create)
  /// - [Moderations Guide](https://beta.openai.com/docs/guides/moderation)
  public struct Create: JSONPostCall {
    
    /// Responds with a ``Moderation``.
    public typealias Response = Moderation
    
    /// The HTTP call path.
    var path: String { "moderations" }
    
    /// The input text to classify.
    public let input: Prompt
    
    /// Two content moderations models are available: ``Moderations/Model/stable`` and ``Moderations/Model/latest``.
    ///
    /// The default is `.latest` which will be automatically upgraded over time.
    /// This ensures you are always using the most accurate model. If you use
    /// `.stable`, we will provide advanced notice before updating the model.
    /// Accuracy of `.stable` may be slightly lower than for `.latest`.
    public let model: Model?
    
    /// Constructs a ``Moderations/Create`` call.
    ///
    /// - Parameters:
    ///   - input: The input text to classify.
    ///   - model: Two content moderations models are available: `.stable` and `.latest`. Defaults to `.latest`.
    public init(input: Prompt, model: Model? = nil) {
      self.input = input
      self.model = model
    }
  }
}

// MARK: Model

extension Moderations {
  /// Two content moderations models are available: ``stable`` and ``latest``.
  public enum Model: String, Equatable, Encodable {
    /// The most accurate model, automatically upgraded over time.
    case latest = "text-moderation-latest"
    /// Advanced notice will be provided before updating the model.
    case stable = "text-moderation-stable"
  }
}
