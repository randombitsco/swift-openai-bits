import Foundation

/// Represents `Completions` requests to the OpenAI API.
///
/// Given a prompt, the model will return one or more predicted completions, and can also return the probabilities of alternative tokens at each position.
///
/// The primary request is the ``Completions/Create`` call, which takes a `prompt` `String`, and returns a ``Completion`` value with a list of choices for the prompt.
///
/// ## See Also
///
/// - [OpenAI API](https://beta.openai.com/docs/api-reference/completions)
/// - [Text Completion Guide](https://beta.openai.com/docs/guides/completion)
/// - [Code Completion Guide](https://beta.openai.com/docs/guides/code)
public enum Completions {}

extension Completions {
  
  /// Creates a completion for the provided prompt and parameters.
  ///
  /// ## Examples
  /// 
  /// *A simple call with the `Davinci` model.*
  /// ```swift
  /// let client = Client(apiKey: ...)
  /// let completion = try await client.call(Completions.Create(
  ///   model: .text_davinci_002,
  ///   prompt: "Peter Piper picked",
  ///   maxTokens: 10,
  ///   temperature: 0.8
  /// ))
  /// ```
  ///
  /// ## See Also
  /// - [OpenAI API](https://beta.openai.com/docs/api-reference/completions/create)
  public struct Create: JSONPostCall {
    /// Responds with a ``Completion``.
    public typealias Response = Completion
    
    var path: String { "completions" }
    
    /// ID of the model to use. You can use ``Models/List`` to see all of your available models, or see the [Model overview](https://beta.openai.com/docs/models/overview) for descriptions of them.
    public let model: Model.ID
    
    /// The prompt(s) to generate completions for, encoded as a string, array of strings, array of tokens, or array of token arrays.
    ///
    /// Note that `<|endoftext|>` is the document separator that the model sees during training, so if a prompt is not specified the model will generate as if from the beginning of a new document.
    public let prompt: Prompt?
    
    /// The suffix that comes after a completion of inserted text.
    public let suffix: String?
    
    /// The maximum number of tokens to generate in the completion.
    ///
    /// The token count of your prompt plus ``maxTokens`` cannot exceed the model's context length. Most models have a context length of `2048` tokens (except for the newest models, which support `4096`).
    public let maxTokens: Int?
    
    /// What [sampling temperature](https://towardsdatascience.com/how-to-sample-from-language-models-682bceb97277) to use.
    /// Higher values means the model will take more risks. Try `0.9` for more creative applications, and `0`
    /// (argmax sampling) for ones with a well-defined answer. Defaults to `1`.
    ///
    /// We generally recommend altering this or ``topP`` but not both.
    public let temperature: Percentage?
    
    /// An alternative to sampling with temperature, called nucleus sampling, where the model considers the results of the tokens with top_p probability mass. So `0.1` means only the tokens comprising the top 10% probability mass are considered. Defaults to `1`.
    ///
    /// It is generally recommend altering this or ``temperature`` but not both.
    public let topP: Percentage?
    
    /// How many completions to generate for each prompt. Defaults to `1`.
    ///
    /// - Note: Because this parameter generates many completions, it can quickly consume your token quota. Use carefully and ensure that you have reasonable settings for ``maxTokens`` and ``stop``.
    public let n: Int?
    
    /// Include the log probabilities on the `logprobs` most likely tokens, as well the chosen tokens. For example, if `logprobs` is `5`, the API will return a list of the 5 most likely tokens. The API will always return the `logprob` of the sampled token, so there may be up to `logprobs+1` elements in the response.
    ///
    /// The maximum value for `logprobs` is 5.
    public let logprobs: Int?
    
    /// Echo back the prompt in addition to the completion. Defaults to `false`.
    public let echo: Bool?
    
    /// Up to `4` sequences where the API will stop generating further tokens. The returned text will not contain the stop sequence.
    public let stop: Stop?
    
    /// Number between `-2.0` and `2.0`. Positive values penalize new tokens based on whether they appear in the text so far, increasing the model's likelihood to talk about new topics. [See more information about frequency and presence penalties](https://beta.openai.com/docs/api-reference/parameter-details)
    public let presencePenalty: Penalty?
    
    /// Number between `-2.0` and `2.0` (defaults to `0`). Positive values penalize new tokens based on their existing frequency in the text so far, decreasing the model's likelihood to repeat the same line verbatim. [See more information about frequency and presence penalties](https://beta.openai.com/docs/api-reference/parameter-details)
    public let frequencyPenalty: Penalty?
    
    /// Generates ``bestOf`` completions server-side and returns the "best" (the one with the highest log probability per token). Results cannot be streamed.
    ///
    /// When used with ``n``, ``bestOf`` controls the number of candidate completions and ``n`` specifies how many to return – ``bestOf`` must be greater than ``n``.
    ///
    /// - Note: Because this parameter generates many completions, it can quickly consume your token quota. Use carefully and ensure that you have reasonable settings for ``maxTokens`` and ``stop``.
    public let bestOf: Int?
    
    /// Modify the likelihood of specified tokens appearing in the completion.
    ///
    /// Accepts a dictionary that maps tokens (specified by their ``Token`` ID from the ``TokenEncoder``) to an associated bias value from `-100` to `100`. You can use this tokenizer tool (which works for both GPT-2 and GPT-3) to convert text to token IDs. Mathematically, the bias is added to the logits generated by the model prior to sampling. The exact effect will vary per model, but values between `-1` and `1` should decrease or increase likelihood of selection; values like `-100` or `100` should result in a ban or exclusive selection of the relevant token.
    ///
    /// As an example, you can pass `[50256: -100]` to prevent the `"<|endoftext|>"` token from being generated.
    @CodableDictionary public var logitBias: [Token: Decimal]?
    
    /// A unique identifier representing your end-user, which will help OpenAI to monitor and detect abuse.
    public let user: String?
    
    /// Creates a completion for the provided prompt and parameters.
    ///
    /// - Parameters:
    ///   - model: ID of the model to use. You can use ``Models/List`` to see all of your available models, or see the [Model overview](https://beta.openai.com/docs/models/overview) for descriptions of them.
    ///   - prompt: The prompt(s) to generate completions for, encoded as a string, array of strings, array of tokens, or array of token arrays.
    ///   - suffix: The suffix that comes after a completion of inserted text.
    ///   - maxTokens: The maximum number of tokens to generate in the completion.
    ///   - temperature: What [sampling temperature](https://towardsdatascience.com/how-to-sample-from-language-models-682bceb97277) to use. Higher values means the model will take more risks. Try `0.9` for more creative applications, and `0` (argmax sampling) for ones with a well-defined answer. Defaults to `1`.
    ///   - topP: An alternative to sampling with temperature, called nucleus sampling, where the model considers the results of the tokens with top_p probability mass. So `0.1` means only the tokens comprising the top 10% probability mass are considered. Defaults to `1`.
    ///   - n: How many completions to generate for each prompt. Defaults to `1`.
    ///   - logprobs: Include the log probabilities on the `logprobs` most likely tokens, as well the chosen tokens. For example, if `logprobs` is `5`, the API will return a list of the 5 most likely tokens. The API will always return the `logprob` of the sampled token, so there may be up to `logprobs+1` elements in the response.
    ///   - echo: Echo back the prompt in addition to the completion. Defaults to `false`.
    ///   - stop: Up to `4` sequences where the API will stop generating further tokens. The returned text will not contain the stop sequence.
    ///   - presencePenalty: Number between `-2.0` and `2.0`. Positive values penalize new tokens based on whether they appear in the text so far, increasing the model's likelihood to talk about new topics. [See more information about frequency and presence penalties](https://beta.openai.com/docs/api-reference/parameter-details)
    ///   - frequencyPenalty: Number between `-2.0` and `2.0` (defaults to `0`). Positive values penalize new tokens based on their existing frequency in the text so far, decreasing the model's likelihood to repeat the same line verbatim. [See more information about frequency and presence penalties](https://beta.openai.com/docs/api-reference/parameter-details)
    ///   - bestOf: Generates ``bestOf`` completions server-side and returns the "best" (the one with the highest log probability per token). Results cannot be streamed.
    ///   - logitBias: Modify the likelihood of specified tokens appearing in the completion. Accepts a dictionary that maps tokens (specified by their ``Token`` ID from the ``TokenEncoder``) to an associated bias value from `-100` to `100`. See ``logitBias`` for details.
    ///   - user: A unique identifier representing your end-user, which will help OpenAI to monitor and detect abuse.
    public init(
      model: Model.ID,
      prompt: Prompt? = nil,
      suffix: String? = nil,
      maxTokens: Int? = nil,
      temperature: Percentage? = nil,
      topP: Percentage? = nil,
      n: Int? = nil,
      logprobs: Int? = nil,
      echo: Bool? = nil,
      stop: Stop? = nil,
      presencePenalty: Penalty? = nil,
      frequencyPenalty: Penalty? = nil,
      bestOf: Int? = nil,
      logitBias: [Token: Decimal]? = nil,
      user: String? = nil
    ) {
      self.model = model
      self.prompt = prompt
      self.suffix = suffix
      self.maxTokens = maxTokens
      self.temperature = temperature
      self.topP = topP
      self.n = n
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

extension Completions {
  /// Represents 1 to 4 "stop" `String` values.
  public struct Stop: Equatable, Encodable {
    /// The "stop" values.
    public let value: [String]
    
    /// A single stop value.
    ///
    /// - Parameter v1: The only `String`.
    public init(_ v1: String) {
      self.value = [v1]
    }
    
    /// Two stop values.
    ///
    /// - Parameters:
    ///   - v1: The first `String`.
    ///   - v2: The second `String`.
    public init(_ v1: String, _ v2: String) {
      self.value = [v1, v2]
    }
    
    /// Three stop values.
    ///
    /// - Parameters:
    ///   - v1: The first `String`.
    ///   - v2: The second `String`.
    ///   - v3: The third `String`.
    public init(_ v1: String, _ v2: String, _ v3: String) {
      self.value = [v1, v2, v3]
    }
    
    /// Four stop values.
    ///
    /// - Parameters:
    ///   - v1: The first `String`.
    ///   - v2: The second `String`.
    ///   - v3: The third `String`.
    ///   - v4: The fourth `String`.
    public init(_ v1: String, _ v2: String, _ v3: String, _ v4: String) {
      self.value = [v1, v2, v3, v4]
    }
    
    /// Encodes the this as a `String` array.
    /// - Parameter encoder: The encoder.
    public func encode(to encoder: Encoder) throws {
      var container = encoder.singleValueContainer()
      try container.encode(value)
    }
  }
}
