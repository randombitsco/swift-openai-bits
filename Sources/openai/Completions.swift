import ArgumentParser
import OpenAIGPT3

struct CompletionsCommand: AsyncParsableCommand {
  static var configuration = CommandConfiguration(
    commandName: "completions",
    abstract: "Runs a \"completions\" request."
  )
  
  @OptionGroup var options: Options
  
  @Option(name: [.customShort("m"), .customLong("model-id")], help: "The ID of the model to prompt.")
  var modelID: Model.ID
  
  @Option(help: "The suffix that comes after a completion of inserted text.")
  var suffix: String?
  
  @Option(help: "The maximum number of tokens to generate in the completion. (Defaults to 16)")
  var maxTokens: Int?
  
  @Option(help: "What sampling temperature to use. Higher values means the model will take more risks. Try 0.9 for more creative applications, and 0 (argmax sampling) for ones with a well-defined answer. (Defaults to 1)")
  var temperature: Percentage?
  
  @Option(name: .customLong("top-p"), help: "An alternative to sampling with temperature, called nucleus sampling, where the model considers the results of the tokens with top-p probability mass. So 0.1 means only the tokens comprising the top 10% probability mass are considered. (Defaults to 1)")
  var topP: Percentage?
  
  @Option(help: "How many completions to generate for each prompt. Note: Because this parameter generates many completions, it can quickly consume your token quota. Use carefully and ensure that you have reasonable settings for max_tokens and stop. (Defaults to 1)")
  var n: Int?
  
  @Option(help: "Whether to stream back partial progress. If set, tokens will be sent as data-only server-sent events as they become available, with the stream terminated by a `data: [DONE]` message. (Defaults to false)")
  var stream: Bool?
  
  @Option(help: "Include the log probabilities on the logprobs most likely tokens, as well the chosen tokens. For example, if logprobs is 5, the API will return a list of the 5 most likely tokens. The API will always return the logprob of the sampled token, so there may be up to logprobs+1 elements in the response. The maximum value for logprobs is 5. (Defaults to nothing)")
  var logprobs: Int?
  
  @Option(help: "Echo back the prompt in addition to the completion. (Defaults to false)")
  var echo: Bool?
  
  @Option(help: "Up to 4 sequences where the API will stop generating further tokens. The returned text will not contain the stop sequence.")
  var stop: String?
  
  @Argument(help: "The prompt to request completions on.")
  var prompt: String
  
  mutating func run() async throws {
    let client = try options.client()
    
    let result = try await client.call(Completions(model: modelID, prompt: .string(prompt)))
    
    print("Completions:")
    for choice in result.choices {
      print("\(choice.index): \"\(choice.text)\"\n")
    }
    
    printUsage(result.usage)
  }
}
