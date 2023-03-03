import Foundation

/// Given a chat conversation, the model will return a chat completion response.
///
/// ## Calls
///
/// - ``Chat/Completions`` - Creates a new chat completion response.
///
/// ## See Also
///
/// - [OpenAI API](https://platform.openai.com/docs/api-reference/chat)
/// - [Chat Guide](https://platform.openai.com/docs/guides/chat/chat-completions-beta)
public enum Chat {}

// MARK: Completions

extension Chat {

  /// A ``Call`` that creates a ``Completion`` for the provided prompt and parameters.
  ///
  /// ## Examples
  ///
  /// ### A simple call with the `GPT 3.5 Turbo` model
  ///
  /// ```swift
  /// let client = OpenAI(apiKey: ...)
  /// let completion = try await client.call(Chat.Completions(
  ///   model: .gpt_3_5_turbo,
  ///   messages: [
  ///     ChatMessage(role: .system, content: "You are a helpful assistant."),
  ///     ChatMessage(role: .user, content: "Who won the world series in 2020?"),
  ///     ChatMessage(role: .assistant, content: "The Los Angeles Dodgers won the World Series in 2020."),
  ///     ChatMessage(role: .user, content: "Where was it played?"),
  ///   ],
  ///   maxTokens: 10,
  ///   temperature: 0.2
  /// ))
  /// ```
  ///
  /// ### A simple call with the `GPT 3.5 Snapshot` model, using fluent `messages` creation
  ///
  /// ```swift
  /// let client = OpenAI(apiKey: ...)
  /// let completion = try await client.call(Chat.Completions(
  ///   model: .gpt_3_5_snapshot("0301"),
  ///   messages: .from(system: "You are a helpful assistant.")
  ///             .from(user: "Who won the world series in 2020?")
  ///             .from(assistant: "The Los Angeles Dodgers won the World Series in 2020.")
  ///             .from(user: "Where was it played?"),
  ///   maxTokens: 10,
  ///   temperature: 0.2
  /// ))
  /// ```
  ///
  /// ## See Also
  ///
  /// - [OpenAI API](https://platform.openai.com/docs/api-reference/chat)
  /// - [Chat Guide](https://platform.openai.com/docs/guides/chat/chat-completions-beta)
  public struct Completions: JSONPostCall {
    /// Responds with a ``ChatCompletion``.
    public typealias Response = ChatCompletion

    var path: String { "chat/completions" }

    /// ID of the model to use. May be ``ChatModel/gpt_3_5_turbo`` or ``ChatModel/gpt_3_5_snapshot(_:)``.
    public let model: ChatModel

    /// The messages to generate chat completions for, in the [chat format](https://platform.openai.com/docs/guides/chat/introduction).
    public let messages: [ChatMessage]

    /// The maximum number of tokens to generate in the completion.
    ///
    /// The token count of your prompt plus ``maxTokens`` cannot exceed the model's context length. Most models have a context length of `2048` tokens (except for the newest models, which support `4096`).
    public let maxTokens: Int?

    /// What [sampling temperature](https://towardsdatascience.com/how-to-sample-from-language-models-682bceb97277) to use.
    /// Higher values means the model will take more risks. Try `0.9` for more creative applications, and `0`
    /// (argmax sampling) for ones with a well-defined answer. Defaults to `1`.
    ///
    /// It is generally recommended to alter this or ``topP`` but not both.
    public let temperature: Percentage?

    /// An alternative to sampling with temperature, called nucleus sampling, where the model considers the results of the tokens with top_p probability mass. So `0.1` means only the tokens comprising the top 10% probability mass are considered. Defaults to `1`.
    ///
    /// It is generally recommended to alter this or ``temperature`` but not both.
    public let topP: Percentage?

    /// How many completions to generate for each prompt. Defaults to `1`.
    ///
    /// - Note: Because this parameter generates many completions, it can quickly consume your token quota. Use carefully and ensure that you have reasonable settings for ``maxTokens`` and ``stop``.
    public let n: Int?

    /// Up to `4` sequences where the API will stop generating further tokens. The returned text will not contain the stop sequence.
    public let stop: Stop?

    /// Number between `-2.0` and `2.0`. Positive values penalize new tokens based on whether they appear in the text so far, increasing the model's likelihood to talk about new topics. [See more information about frequency and presence penalties](https://platform.openai.com/docs/api-reference/parameter-details)
    public let presencePenalty: Penalty?

    /// Number between `-2.0` and `2.0` (defaults to `0`). Positive values penalize new tokens based on their existing frequency in the text so far, decreasing the model's likelihood to repeat the same line verbatim. [See more information about frequency and presence penalties](https://platform.openai.com/docs/api-reference/parameter-details)
    public let frequencyPenalty: Penalty?

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
    ///   - model: ID of the model to use. You can use ``Models/List`` to see all of your available models, or see the [Model overview](https://platform.openai.com/docs/models/overview) for descriptions of them.
    ///   - messages: The list of ``ChatMessage`` values to send.
    ///   - suffix: The suffix that comes after a completion of inserted text.
    ///   - maxTokens: The maximum number of tokens to generate in the completion.
    ///   - temperature: What [sampling temperature](https://towardsdatascience.com/how-to-sample-from-language-models-682bceb97277) to use. Higher values means the model will take more risks. Try `0.9` for more creative applications, and `0` (argmax sampling) for ones with a well-defined answer. Defaults to `1`.
    ///   - topP: An alternative to sampling with temperature, called nucleus sampling, where the model considers the results of the tokens with top_p probability mass. So `0.1` means only the tokens comprising the top 10% probability mass are considered. Defaults to `1`.
    ///   - n: How many completions to generate for each prompt. Defaults to `1`.
    ///   - stop: Up to `4` sequences where the API will stop generating further tokens. The returned text will not contain the stop sequence.
    ///   - presencePenalty: Number between `-2.0` and `2.0`. Positive values penalize new tokens based on whether they appear in the text so far, increasing the model's likelihood to talk about new topics. [See more information about frequency and presence penalties](https://platform.openai.com/docs/api-reference/parameter-details)
    ///   - frequencyPenalty: Number between `-2.0` and `2.0` (defaults to `0`). Positive values penalize new tokens based on their existing frequency in the text so far, decreasing the model's likelihood to repeat the same line verbatim. [See more information about frequency and presence penalties](https://platform.openai.com/docs/api-reference/parameter-details)
    ///   - logitBias: Modify the likelihood of specified tokens appearing in the completion. Accepts a dictionary that maps tokens (specified by their ``Token`` ID from the ``TokenEncoder``) to an associated bias value from `-100` to `100`. See ``logitBias`` for details.
    ///   - user: A unique identifier representing your end-user, which will help OpenAI to monitor and detect abuse.
    public init(
      model: ChatModel,
      messages: [ChatMessage],
      maxTokens: Int? = nil,
      temperature: Percentage? = nil,
      topP: Percentage? = nil,
      n: Int? = nil,
      stop: Stop? = nil,
      presencePenalty: Penalty? = nil,
      frequencyPenalty: Penalty? = nil,
      logitBias: [Token: Decimal]? = nil,
      user: String? = nil
    ) {
      self.model = model
      self.messages = messages
      self.maxTokens = maxTokens
      self.temperature = temperature
      self.topP = topP
      self.n = n
      self.stop = stop
      self.presencePenalty = presencePenalty
      self.frequencyPenalty = frequencyPenalty
      self.logitBias = logitBias
      self.user = user
    }
  }
}
