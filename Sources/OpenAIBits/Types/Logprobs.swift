public struct Logprob: Codable, Equatable {
    public let tokens: [String]
    public let tokenLogprobs: [Double]
    public let topLogprobs: [[String: Double]]
    public let textOffset: [Int]
}