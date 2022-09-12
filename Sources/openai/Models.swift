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
  
  @Flag(help: "If set, only models compatible with 'edits' calls will be listed.")
  var edits: Bool = false
  
  @Flag(help: "If set, only models compatible optimised for code generation will be listed.")
  var code: Bool = false
  
  @Flag(help: "If set, only models compatible with 'insert'calls will be listed.")
  var insert: Bool = false
  
  @Option(help: "A text value the model name must include.")
  var includes: String?
  
  mutating func run() async throws {
    let client = try options.client()
    
    var models = try await client.call(Models.List()).data
    
    if edits {
      models = models.filter { $0.supportsEdit }
    }
    
    if code {
      models = models.filter { $0.supportsCode }
    }
    
    if insert {
      models = models.filter { $0.supportsInsert }
    }
    
    if let includes = includes {
      models = models.filter { $0.id.value.contains(includes) }
    }
    
    print("Models:")
    for model in models.sorted(by: { $0.id.value < $1.id.value }) {
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
