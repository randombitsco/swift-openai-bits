import Foundation
import ArgumentParser
import OpenAIAPI

struct ModerationsCommand: AsyncParsableCommand {
  static var configuration = CommandConfiguration(
    commandName: "moderations",
    abstract: "Given a input text, outputs if the model classifies it as violating OpenAI's content policy."
  )
  
  @Argument(help: "The input text to classify.")
  var input: String
  
  @Flag(help: "Uses the stable classifier model, which updates less frequently. Accuracy may be slightly lower than 'latest'.")
  var stable: Bool = false
  
  @OptionGroup var config: Config

  mutating func run() async throws {
    let client = config.client()
    
    let response = try await client.call(Moderations(
      input: .string(input),
      model: stable == true ? .stable : .latest
    ))
    
    print(title: "Moderations", format: config.format())
    print(moderationsResponse: response, format: config.format())
  }
}
