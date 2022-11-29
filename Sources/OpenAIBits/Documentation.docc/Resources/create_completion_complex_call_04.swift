import OpenAIBits

// Note: Don't store your API Key in source code
let openai = OpenAI(apiKey: "<my-unique-key>")

let humptyDumpty = Completions.Create(
  id: .text_davinci_002,
  prompt: "Humpty Dumpty sat",
  maxTokens: 200,
  temperature: 0.5,
  n: 3
)

do {
  let result: Completion = try await openai.call(humptyDumpty)
  
  for (i, choice) in result.choices.enumerated() {
    print("Result #\(i): \(choice.text)")
  }
} catch {
  print("An error occurred: \(error)")
}
