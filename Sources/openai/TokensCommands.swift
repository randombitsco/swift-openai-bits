import ArgumentParser
import Foundation
import OpenAIBits

struct TokensCommand: AsyncParsableCommand {
  static var configuration = CommandConfiguration(
    commandName: "tokens",
    abstract: "Commands relating to tokens",
    subcommands: [TokensCountCommand.self, TokensListCommand.self],
    defaultSubcommand: TokensCountCommand.self
  )
}

struct TokensCountCommand: AsyncParsableCommand {
  static var configuration = CommandConfiguration(
    commandName: "count",
    abstract: "Estimates the number of tokens a prompt will be encoded into.",
    discussion: "This is performed locally, based on the published GPT-2/3 token encoder."
  )
  
  @Argument(help: "The prompt to estimate tokens for.")
  var prompt: String
  
  mutating func run() async throws {
    let encoder = try TokenEncoder()
    let count = try encoder.encode(text: prompt).count
    
    print(title: "Token Count", format: .default)
    print("")
    print(label: "Count", value: count, format: .default)
  }
}

struct TokensListCommand: AsyncParsableCommand {
  static var configuration = CommandConfiguration(
    commandName: "list",
    abstract: "Generates an estimated list of the tokens a prompt will be encoded into.",
    discussion: "This is performed locally, based on the published GPT-2/3 token encoder."
  )
  
  @Argument(help: "The prompt to estimate tokens for.")
  var prompt: String
  
  
  @Flag(help: "Output more details.")
  var verbose: Bool = false
  
  var format: Format {
    verbose ? .verbose() : .default
  }
  
  mutating func run() async throws {
    let encoder = try TokenEncoder()
    let tokens = try encoder.encode(text: prompt)
    
    print(title: "Token Encoding", format: format)
    print("")
    print(label: "Text", value: prompt, verbose: true, format: format)
    print(label: "Tokens", value: tokens, format: format)
    print(label: "Count", value: tokens.count, verbose: true, format: format)
  }
}
