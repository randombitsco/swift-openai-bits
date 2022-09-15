import OpenAIAPI

struct EmbeddingsCommand: AsyncParsableCommand {
  static var configuration = CommandConfiguration(
    commandName: "edits",
    abstract: "Runs an \"edits\" request."
  )
  
  @OptionGroup var config: Config

  @Option(help: "The model ID to use creating the embeddings.")
  var modelId: Model.ID

  @Option(help: "The text prompt to generate the embeddings.")
  var prompt: String

  @Option(help: "A unique identifier representing your end-user, which will help OpenAI to monitor and detect abuse.")
  var user: String?

  @Option(help: "A filename to save the embedding into as a JSON file.", completion: .file("json"))
  var output: String

  mutating func run() throws async {
    let client = config.client()

    let result = client.call(Embeddings(
      model: modelId, 
      prompt: .string(prompt), 
      user: user
    ))

    print(title: "Embeddings", format: config.format())

    print(usage: result.usage, format: config.format())
    
    let outputURL = URL(fileURLWithPath: output)
    let jsonData = try jsonEncodeData(request.data)
    try jsonData.write(to: outputURL)
    print(label: "JSON File Saved:", value: output, format: config.format())

  }
}