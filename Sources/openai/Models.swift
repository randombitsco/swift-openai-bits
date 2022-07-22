import ArgumentParser
import Foundation
import OpenAIGPT3

func printModel(_ model: Model) {
  print("""
  ID: \(model.id)
  Created: \(model.created)
  """)
}

extension Model.ID: ExpressibleByArgument {
  public init(argument: String) {
    self.init(argument)
  }
}

struct ModelsCommand: AsyncParsableCommand {
  static var configuration = CommandConfiguration(
    commandName: "models",
    abstract: "Commands relating to available models.",
    subcommands: [ModelsListCommand.self, ModelsDetailCommand.self]
  )
}

struct ModelsListCommand: AsyncParsableCommand {
  static var configuration = CommandConfiguration(
    commandName: "list",
    abstract: "List available models."
  )
  
  @OptionGroup var options: Options
  
  mutating func run() async throws {
    let client = try options.client()
    
    let models = try await client.call(Models.List())
    
    print("Models:")
    for model in models.data.sorted(by: { $0.id.value < $1.id.value }) {
      print("- \(model.id)")
    }
  }
}

struct ModelsDetailCommand: AsyncParsableCommand {
  static var configuration = CommandConfiguration(
    commandName: "detail",
    abstract: "Outputs details for model with a specific ID."
  )
  
  @OptionGroup var options: Options
  
  @Argument(help: "The model ID.")
  var id: Model.ID
  
  mutating func run() async throws {
    let client = try options.client()

    try await printModel(client.call(Models.Details(for: id)))
  }
}
