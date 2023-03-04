import OpenAIBits

// Note: Don't store your API Key in source code
let openai = OpenAI(apiKey: "sk-<my-unique-key>")

/// Fixes the grammar in the provided input.
/// - Parameter input: The input text to fix.
/// - Returns the first
func fixGrammar(in input: String) async throws -> String {
  let request = try await openai.call(Text.Edits(
    id: .text_davinci_edit_001,
    input: input,
    instruction: "Fix the grammar and spelling."
  ))
  return request.text
}
