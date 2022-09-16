import ArgumentParser
import Foundation
import OpenAIBits

struct EditsCommand: AsyncParsableCommand {
  static var configuration = CommandConfiguration(
    commandName: "edits",
    abstract: "Runs an \"edits\" request."
  )
  
  @Option(name: .long, help: "Either 'davinci' or 'codex'.")
  var model: EditsModel?
  
  @Option(help: "The full ID of the model to prompt. Must be an 'edit' model.")
  var modelId: Model.ID?
  
  @Argument(help: "The input text to use as a starting point for the edit. (Defaults to '')")
  var input: String?
  
  @Option(name: .shortAndLong, help: "The instruction that tells the model how to edit the prompt.")
  var instruction: String
  
  @Option(name: .short, help: "How many edits to generate for the input and instruction. (Defaults to 1)")
  var n: Int?
  
  @Option(help: "What sampling temperature to use. Higher values means the model will take more risks. Try 0.9 for more creative applications, and 0 (argmax sampling) for ones with a well-defined answer. We generally recommend altering this or `top-p` but not both. (Defaults to 1)")
  var temperature: Percentage?
  
  @Option(name: .customLong("top-p"), help: "An alternative to sampling with temperature, called nucleus sampling, where the model considers the results of the tokens with top-p probability mass. So 0.1 means only the tokens comprising the top 10% probability mass are considered. We generally recommend altering this or `temperature` but not both. (Defaults to 1)")
  var topP: Percentage?
  
  @OptionGroup var config: Config
  
  func findModelID() throws -> Model.ID {
    switch (model, modelId) {
    case (.none, .none):
      throw ValidationError("Please specify either 'model' or 'model-id'.")
    case (.none, let .some(modelID)):
      return modelID
    case (let .some(model), .none):
      return model.id
    case (.some, .some):
      throw ValidationError("Please specify either 'model' or 'model-id', not both.")
    }
  }
  
  mutating func run() async throws {
    let client = config.client()
    
    let edits = Edits(
      model: try findModelID(),
      input: input,
      instruction: instruction,
      n: n,
      temperature: temperature,
      topP: topP
    )
    
    let result = try await client.call(edits)
    
    print(title: "Edits", format: config.format())
    for choice in result.choices {
      print("\(choice.index): \"\(choice.text)\"\n")
    }
    
    print(usage: result.usage, format: config.format())
  }
}

extension EditsCommand {
  enum EditsModel: String, ExpressibleByArgument {
    case davinci = "edits-davinci-002"
    case codex = "edits-davinci-codex-002"
    
    init?(argument: String) {
      self.init(rawValue: argument)
    }
    
    var id: Model.ID {
      .init(rawValue)
    }
  }
  
}
