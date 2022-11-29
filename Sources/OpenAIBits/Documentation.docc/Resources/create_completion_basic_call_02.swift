import OpenAIBits

// Note: Don't store your API Key in source code
let openai = OpenAI(apiKey: "<my-unique-key>")

let humptyDumpty = Completions.Create(
  id: .text_davinci_002,
  prompt: "Humpty Dumpty sat"
)

do {
  let result: Completion = try await openai.call(humptyDumpty)
} catch {
  print("An error occurred: \(error)")
}
