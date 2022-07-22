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
  
  @Option(help: "The maximum number of tokens to generate in the completion. Defaults to 16.")
  var maxTokens: Int?
  
  @Option(help: "What sampling temperature to use. Higher values means the model will take more risks. Defaults to 1. Try 0.9 for more creative applications, and 0 (argmax sampling) for ones with a well-defined answer.")
  var temperature: Percentage?
  
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
