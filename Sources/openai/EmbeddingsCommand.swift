import ArgumentParser
import Foundation
import OpenAIBits

struct EmbeddingsCommand: AsyncParsableCommand {
  static var configuration = CommandConfiguration(
    commandName: "embeddings",
    abstract: "Runs an \"embeddings\" request, saving the results into a JSON file."
  )
  
  @Option(help: "The model ID to use creating the embeddings.")
  var modelId: Model.ID

  @Option(help: "A unique identifier representing your end-user, which will help OpenAI to monitor and detect abuse.")
  var user: String?

  @Option(help: "A filename to save the embedding into as a JSON file.", completion: .file(extensions: ["json"]))
  var output: String

  @Argument(help: "The text prompt to generate the embeddings.")
  var input: String
  
  @OptionGroup var config: Config

  mutating func run() async throws {
    let client = config.client()

    let result = try await client.call(Embeddings(
      model: modelId, 
      input: .string(input),
      user: user
    ))

    print(title: "Embeddings", format: config.format())

    print(usage: result.usage, format: config.format())
    
    let outputURL = URL(fileURLWithPath: output)
    let jsonData = try JSONEncoder().encode(result.data)
    try jsonData.write(to: outputURL)
    print(label: "JSON File Saved:", value: output, format: config.format())

  }
}
