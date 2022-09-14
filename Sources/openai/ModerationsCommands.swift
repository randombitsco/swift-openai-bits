import Foundation
import ArgumentParser
import OpenAIAPI

func printModerationsResponse(_ response: Moderations.Response) {
  print("Moderations:")
  let maxCategoryName = Moderations.Category.allCases.map { $0.rawValue.count }.max() ?? 0
  for (i, result) in response.results.enumerated() {
    print("#\(i+1): \(result.flagged ? "FLAGGED" : "Unflagged") ")
    for category in Moderations.Category.allCases {
      var output = "N/A"
      if let flagged = result.categories[category] {
        output = flagged ? "YES" : "no "
      }
      if let score = result.categoryScores[category] {
        output += " (\(score))"
      }
      let categoryName = "\(category):".padding(toLength: maxCategoryName+1, withPad: " ", startingAt: 0)
      print("\(categoryName) \(output)")
    }
  }
}

struct ModerationsCommand: AsyncParsableCommand {
  static var configuration = CommandConfiguration(
    commandName: "moderations",
    abstract: "Given a input text, outputs if the model classifies it as violating OpenAI's content policy."
  )
  
  @OptionGroup var config: Config
  
  @Argument(help: "The input text to classify.")
  var input: String
  
  @Flag(help: "Uses the stable classifier model, which updates less frequently. Accuracy may be slightly lower than 'latest'.")
  var stable: Bool = false
  
  mutating func run() async throws {
    let client = config.client()
    
    let response = try await client.call(Moderations(
      input: .string(input),
      model: stable == true ? .stable : .latest
    ))
    
    printModerationsResponse(response)
  }
}
