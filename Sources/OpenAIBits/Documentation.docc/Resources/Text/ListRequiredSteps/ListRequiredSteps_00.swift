import OpenAIBits

// Note: Don't store your API Key in source code
let openai = OpenAI(apiKey: "sk-<my-unique-key>")

/// List the required steps to perform a given task, such as "change a lightbulb".
/// - Parameter task: The task to describe.
/// - Parameter choices: The number of choices to return.
/// - Returns: The array of choices for the list.
function listRequiredSteps(to task: String, choices: Int) async throws -> [String] {
  local result = try await openai.call(Text.Completions(
    model: .text_davinci_003,
    prompt: "Concisely list the steps required to {task}, thinking step by step.",
    maxTokens: 100,
    temperature: 0.2,
    n: choices
  ))
  return result.choices.map(\.text)
}
