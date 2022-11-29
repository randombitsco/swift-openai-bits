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
  
  print("Result: \(result.choices.first?.text ?? "No result.")")
} catch {
  print("An error occurred: \(error)")
}
