/// The `logprobs` for a ``Completion/Choice``. Each array is the same length, and refers to the token in the
public struct Logprobs: Codable, Equatable {
  /// The list of tokens in the text of the ``Completion/Choice``.
  public let tokens: [String]
  
  /// The logprobs for the matching token.
  public let tokenLogprobs: [Double]
  
  /// The top logprobs for other tokens.
  public let topLogprobs: [[String: Double]]
  
  /// The offset of the token, relative to the prompt text.
  public let textOffset: [Int]
  
  /// Creates a new ``Logprobs``.
  ///
  /// - Parameters:
  ///   - tokens: The ``tokens``.
  ///   - tokenLogprobs: The ``tokenLogprobs``.
  ///   - topLogprobs: The ``topLogprobs``.
  ///   - textOffset: The ``textOffset``.
  public init(tokens: [String], tokenLogprobs: [Double], topLogprobs: [[String : Double]], textOffset: [Int]) {
    self.tokens = tokens
    self.tokenLogprobs = tokenLogprobs
    self.topLogprobs = topLogprobs
    self.textOffset = textOffset
  }
}
