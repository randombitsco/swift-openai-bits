import Foundation

/// Used to call the API for a [Completions](https://beta.openai.com/docs/api-reference/completions)
/// response.
public struct Completions: JSONPostCall {
  public var path: String { "completions" }
  
  public let model: Model.ID
  public let prompt: Prompt?
  public let suffix: String?
  public let maxTokens: Int?
  public let temperature: Percentage?
  public let topP: Percentage?
  public let n: Int?
  public let stream: Bool
  public let logprobs: Int?
  public let echo: Bool
  public let stop: [String]?
  public let presencePenalty: Penalty?
  public let frequencyPenalty: Penalty?
  public let bestOf: Int?
  public let logitBias: [Token: Double]?
  public let user: String?

  public init(
    model: Model.ID,
    prompt: Prompt? = nil,
    suffix: String? = nil,
    maxTokens: Int? = nil,
    temperature: Percentage? = nil,
    topP: Percentage? = nil,
    n: Int? = nil,
    stream: Bool = false,
    logprobs: Int? = nil,
    echo: Bool = false,
    stop: [String]? = nil,
    presencePenalty: Penalty? = nil,
    frequencyPenalty: Penalty? = nil,
    bestOf: Int? = nil,
    logitBias: [Token: Double]? = nil,
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

extension Completions {
  /// Response from a `completions` request.
  public struct Response: JSONResponse, Equatable {
    public struct ID: Identifier {
      public let value: String

      public init(_ value: String) {
        self.value = value
      }
    }

    public let id: ID
    public let created: Date
    public let model: Model.ID
    public let choices: [Choice]
    public let usage: Usage

    public init(
      id: ID,
      created: Date,
      model: Model.ID,
      choices: [Choice],
      usage: Usage
    ) {
      self.id = id
      self.created = created
      self.model = model
      self.choices = choices
      self.usage = usage
    }
  }

  /// One of the completion choices.
  public struct Choice: Equatable, Codable {
    /// The text of the completion.
    public let text: String

    /// Which completion number.
    public let index: Int

    /// The list of `logprobs`.
    public let logprobs: [String]?

    /// The reason for finishing.
    public let finishReason: String

    public init(
      text: String,
      index: Int,
      logprobs: [String]? = nil,
      finishReason: String
    ) {
      self.text = text
      self.index = index
      self.logprobs = logprobs
      self.finishReason = finishReason
    }
  }
}
