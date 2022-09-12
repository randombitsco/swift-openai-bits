import ArgumentParser
import Foundation
import OpenAIGPT3

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
    
    print("Tokens: \(count)")
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
  
  mutating func run() async throws {
    let encoder = try TokenEncoder()
    let tokens = try encoder.encode(text: prompt)
    
    print("Tokens: \(tokens)")
  }
}
