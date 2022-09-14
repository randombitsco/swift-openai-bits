import ArgumentParser
import Foundation
import OpenAIAPI

struct AppError: Error, CustomStringConvertible {
  let description: String
  
  init(_ description: String) {
    self.description = description
  }
}

@main
struct openai: AsyncParsableCommand {
  
  static var configuration = CommandConfiguration(
    abstract: "A utility for accessing OpenAI APIs.",
    
    version: "0.1.0",
    
    subcommands: [
      ModelsCommand.self,
      CompletionsCommand.self,
      EditsCommand.self,
      FileCommand.self,
      TokensCommand.self,
    ]
  )
}

struct Config: ParsableArguments {
  @Option(help: "The OpenAI API Key. If not provided, uses the 'OPENAI_API_KEY' environment variable.")
  var apiKey: String?
  
  @Option(help: "The OpenAI Organisation key. If not provided, uses the 'OPENAI_ORG_KEY' environment variable.")
  var orgKey: String?
  
  @Flag(help: "Output debugging information.")
  var debug: Bool = false
  
  func findApiKey() -> String? {
    apiKey ?? ProcessInfo.processInfo.environment["OPENAI_API_KEY"]
  }
  
  func findOrgKey() -> String? {
    orgKey ?? ProcessInfo.processInfo.environment["OPENAI_ORG_KEY"]
  }
  
  var log: Client.Logger? {
    guard debug else {
      return nil
    }
    return { print($0) }
  }
  
  func client() -> Client {
    Client(apiKey: findApiKey() ?? "NO API KEY PROVIDED", organization: findOrgKey(), log: log)
  }
  
  mutating func validate() throws {
    guard findApiKey() != nil else {
      throw ValidationError("Please provide an OpenAI API Key either via --api-key or the 'OPENAI_API_KEY' environment variable.")
    }
  }
}

extension Percentage: ExpressibleByArgument {
  public init?(argument: String) {
    guard let value = Double.init(argument: argument) else {
      return nil
    }
    self.init(value)
  }
}

extension Penalty: ExpressibleByArgument {
  public init?(argument: String) {
    guard let value = Double.init(argument: argument) else {
      return nil
    }
    self.init(value)
  }
}
