import UIKit
import OpenAIBits

struct PlaygroundError: Error {
  let message: String
  
  init(_ message: String) {
    self.message = message
  }
}

// Store your own OpenAI API key in an environment variable called `"OPENAI_API_KEY"`.
guard let apiKey = ProcessInfo.processInfo.environment["OPENAI_API_KEY"] else {
  throw PlaygroundError("Set an environment variable named 'OPENAI_API_KEY'")
}

let openai = OpenAI(apiKey: apiKey)

let models = try await openai.call(Models.List())

for model in models.data {
  print(model)
}
