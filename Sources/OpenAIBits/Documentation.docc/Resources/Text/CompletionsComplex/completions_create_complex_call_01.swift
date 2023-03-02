import OpenAIBits

// Note: Don't store your API Key in source code
let openai = OpenAI(apiKey: "sk-<my-unique-key>")

let request = Text.Completions(
  id: .text_davinci_003,
  prompt: "Humpty Dumpty sat",
  maxTokens: 200,
  temperature: 0.5,
  n: 3
)

do {
  let result: Completion = try await openai.call(request)
  
  print("Result: \(result.text)")
} catch {
  print("An error occurred: \(error)")
}
