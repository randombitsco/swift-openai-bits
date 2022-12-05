import OpenAIBits

// Note: Don't store your API Key in source code
let openai = OpenAI(apiKey: "sk-<my-unique-key>")

/// Fixes the grammar in the provided input.
/// - Parameter input: The input text to fix.
/// - Returns the first
func fixGrammar(in input: String) async throws -> String {
  let request = try await openai.call(Edits.Create(
    id: .text_davinci_edit_001,
    input: input,
    instruction: "Fix the grammar and spelling.",
    temperature: 0.0
  ))
  return request.text
}

@main
struct MainApp {
  static func main() async {
    print(try! await fixGrammar(in: "Pleas fx the grammer, and spelling."))
  }
}
