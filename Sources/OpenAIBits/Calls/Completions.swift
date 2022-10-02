import Foundation

/// Used to call the API for a [Completions](https://beta.openai.com/docs/api-reference/completions)
/// request.

public enum Completions {}

extension Completions {
  public struct Create: JSONPostCall {
    public typealias Response = Completion
    
    public var path: String { "completions" }
    
    public let model: Model.ID
    public let prompt: Prompt?
    public let suffix: String?
    public let maxTokens: Int?
    public let temperature: Percentage?
    public let topP: Percentage?
    public let n: Int?
    public let stream: Bool?
    public let logprobs: Int?
    public let echo: Bool?
    public let stop: [String]?
    public let presencePenalty: Penalty?
    public let frequencyPenalty: Penalty?
    public let bestOf: Int?
    @CodableDictionary public var logitBias: [Token: Int8]?
    public let user: String?
    
    public init(
      model: Model.ID,
      prompt: Prompt? = nil,
      suffix: String? = nil,
      maxTokens: Int? = nil,
      temperature: Percentage? = nil,
      topP: Percentage? = nil,
      n: Int? = nil,
      stream: Bool? = nil,
      logprobs: Int? = nil,
      echo: Bool? = nil,
      stop: [String]? = nil,
      presencePenalty: Penalty? = nil,
      frequencyPenalty: Penalty? = nil,
      bestOf: Int? = nil,
      logitBias: [Token: Int8]? = nil,
      user: String? = nil
    ) {
      self.model = model
      self.prompt = prompt
      self.suffix = suffix
      self.maxTokens = maxTokens
      self.temperature = temperature
      self.topP = topP
      self.n = n
      self.stream = stream
      self.logprobs = logprobs
      self.echo = echo
      self.stop = stop
      self.presencePenalty = presencePenalty
      self.frequencyPenalty = frequencyPenalty
      self.bestOf = bestOf
      self.logitBias = logitBias
      self.user = user
    }
  }
}
