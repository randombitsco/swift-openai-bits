/// Create a vector representation of a given input that can be easily consumed by machine learning models and algorithms.
///
/// ## Calls
///
/// - ``Embeddings/Create`` - Creates a new embedding vector for a given text input.
///
/// ## See Also
/// - [OpenAI API](https://platform.openai.com/docs/api-reference/embeddings)
/// - [Embeddings Guide](https://platform.openai.com/docs/guides/embeddings)
public enum Embeddings {}

// MARK: Create

extension Embeddings {
  
  /// A ``Call`` that creates an embedding vector representing the input text.
  ///
  /// ## See Also
  /// 
  /// - [OpenAI API](https://platform.openai.com/docs/api-reference/embeddings/create)
  /// - [Embeddings Guide](https://platform.openai.com/docs/guides/embeddings)
  public struct Create: JSONPostCall, Equatable {
    
    /// The input to an ``Embeddings/Create`` ``Call`` is either a `.string(...)` or
    /// an array of `.tokens(...)`.
    ///
    /// ## Notes
    ///
    /// - The `.strings` case can be created directly with a `"String Value"`, and\
    ///   the `.tokens` case can be created directly with an `[123, 456]` array of ``Token``s.
    public enum Input: Equatable {
      /// The input as a `String`.
      case string(String)
      
      /// The input as an array of ``Token``s.
      case tokens([Token])
    }
    
    /// The path to the API endpoint.
    var path: String { "embeddings" }
    
    /// Responds with a ``ListOf`` ``Embedding`` values.
    public typealias Response = ListOf<Embedding>
    
    /// ID of the model to use. You can use the ``Models/List`` ``Call`` to see all of
    /// your available models, or see the [Model overview](https://platform.openai.com/docs/models/overview)
    /// for descriptions of them.
    public let model: Model.ID
    
    /// Input text to get embeddings for, encoded as a string or array of tokens. To get embeddings for multiple inputs in a single request, pass an array of strings or array of token arrays. Each input must not exceed 2048 tokens in length.
    ///
    /// Unless you are embedding code, we suggest replacing newlines (`"\n"`) in your input with a single space, as we have observed inferior results when newlines are present.
    public let input: Input
    
    /// A unique identifier representing your end-user, which will help OpenAI to monitor and detect abuse.
    public let user: String?
    
    /// Constructs a `Create` call.
    ///
    /// - Parameters:
    ///   - model: ID of the model to use.
    ///   - input: Input text to get embeddings for, encoded as a string or array of tokens.
    ///   - user: A unique identifier representing your end-user, which will help OpenAI to monitor and detect abuse.
    public init(model: Model.ID, input: Input, user: String? = nil) {
      self.model = model
      self.input = input
      self.user = user
    }
  }
}

// MARK: Expressible

extension Embeddings.Create.Input: ExpressibleByStringLiteral, ExpressibleByStringInterpolation {
  /// Initializes the `Input` with a `String` literal value.
  ///
  /// - Parameter stringLiteral: The `String`.
  public init(stringLiteral value: String) {
    self = .string(value)
  }
}

extension Embeddings.Create.Input: ExpressibleByArrayLiteral {
  /// Initializes the `Input` with an array of ``Token``s.
  ///
  /// - Parameter arrayLiteral: The array of ``Token``s.
  public init(arrayLiteral elements: Token...) {
    self = .tokens(elements)
  }
}

// MARK: Codable

extension Embeddings.Create.Input: Codable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    do {
      self = .string(try container.decode(String.self))
      return
    } catch {}
    
    self = .tokens(try container.decode([Token].self))
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    switch self {
    case .string(let value):
      try container.encode(value)
    case .tokens(let tokens):
      try container.encode(tokens)
    }
  }
}

