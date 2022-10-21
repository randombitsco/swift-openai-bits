/// Represents ``Token`` usage for a request.
public struct Usage: Equatable, Codable {
  /// The number of ``Token``s in the prompt.
  public let promptTokens: Int
  
  /// The number of ``Token``s in the completion choices.
  public let completionTokens: Int?
  
  /// The total number of ``Tokens``s.
  public let totalTokens: Int
  
  /// Creates a ``Usage`` report.
  ///
  /// - Parameters:
  ///   - promptTokens: The ``promptTokens``.
  ///   - completionTokens: The ``completionTokens``.
  ///   - totalTokens: The ``totalTokens``.
  public init(promptTokens: Int, completionTokens: Int?, totalTokens: Int) {
    self.promptTokens = promptTokens
    self.completionTokens = completionTokens
    self.totalTokens = totalTokens
  }
}
