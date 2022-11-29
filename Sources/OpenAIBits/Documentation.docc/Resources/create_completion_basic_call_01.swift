import OpenAIBits

// Note: Don't store your API Key in source code
let openai = OpenAI(apiKey: "<my-unique-key>")

let humptyDumpty = Completions.Create(
  id: .text_davinci_002,
  prompt: "Humpty Dumpty sat"
)
