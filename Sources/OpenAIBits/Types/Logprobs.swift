public struct Logprobs: Codable, Equatable {
  public let tokens: [String]
  public let tokenLogprobs: [Double]
  public let topLogprobs: [[String: Double]]
  public let textOffset: [Int]

  public init(tokens: [String], tokenLogprobs: [Double], topLogprobs: [[String : Double]], textOffset: [Int]) {
    self.tokens = tokens
    self.tokenLogprobs = tokenLogprobs
    self.topLogprobs = topLogprobs
    self.textOffset = textOffset
  }
}
