/// Represents Usage for a request.
public struct Usage: Equatable, Codable {
  public let promptTokens: Int
  public let completionTokens: Int?
  public let totalTokens: Int
  
  public init(promptTokens: Int, completionTokens: Int?, totalTokens: Int) {
    self.promptTokens = promptTokens
    self.completionTokens = completionTokens
    self.totalTokens = totalTokens
  }
}
