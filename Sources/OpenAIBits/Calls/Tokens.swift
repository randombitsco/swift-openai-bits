/// Encoding and decoding text to and from tokens.
///
/// ## See Also
///
/// - ``TokenEncoder``
public enum Tokens {}

// MARK: Encode

extension Tokens {
  
  /// Encodes the provided ``input`` `String`and encodes it into an array of ``Token``s.
  public struct Encode: ExecutableCall {
    /// Responds with an array of ``Token``s.
    public typealias Response = [Token]
    
    /// The input `String`.
    public let input: String
  }
}

extension Tokens.Encode {
  
  /// Executes the call with the provided ``OpenAI``.
  /// - Parameter client: The ``OpenAI`` details.
  /// - Returns: The list of tokens.
  func execute(with client: OpenAI) async throws -> Response {
    let encoder = try TokenEncoder()
    return try encoder.encode(text: input)
  }
}

// MARK: Decode

extension Tokens {
  
  fileprivate static var encoder: TokenEncoder?
  
  /// Retrieves or creates a new ``TokenEncoder``
  /// - Returns: The ``TokenEncoder``
  static func getEncoder() throws -> TokenEncoder {
    if let encoder = encoder {
      return encoder
    }
    let encoder = try TokenEncoder()
    Self.encoder = encoder
    return encoder
  }
  
  /// Decodes the provided list of ``Token``s into a `String`.
  public struct Decode: ExecutableCall {
    /// Responds with a `String.
    public typealias Response = String
    
    /// The input ``Token``s.
    public let input: [Token]
  }
}

extension Tokens.Decode {
  /// Executes the call with the provided ``OpenAI``.
  /// - Parameter client: The ``OpenAI`` details.
  /// - Returns: The `String` result.
  func execute(with client: OpenAI) async throws -> String {
    let encoder = try Tokens.getEncoder()
    return try encoder.decode(tokens: input)
  }
}

// MARK: Count

extension Tokens {
  struct Count: ExecutableCall {
    typealias Response = Int
    
    public let input: String
    
    func execute(with client: OpenAI) async throws -> Int {
      let encoder = try Tokens.getEncoder()
      return try encoder.encode(text: input).count
    }
  }
}
