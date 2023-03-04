import OpenAIBits

// Note: Don't store your API Key in source code
let openai = OpenAI(apiKey: "sk-<my-unique-key>")

let request = Completions.Create(
  id: .text_davinci_003,
  prompt: "Humpty Dumpty sat"
)

do {
  let result: Completion = try await openai.call(request)
  print("Result: \(result.choices[0].text)")
} catch {
  print("An error occurred: \(error)")
}
