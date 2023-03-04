import OpenAIBits

// Note: Don't store your API Key in source code
let openai = OpenAI(apiKey: "sk-<my-unique-key>")

/// List the required steps to perform a given task, such as "change a lightbulb".
/// - Parameter task: The task to describe.
/// - Returns: The list of steps.
func listRequiredSteps(to task: String) -> String {
  let result = try await openai.call(Text.Completions(
    model: .text_davinci_003,
    prompt: "List the required steps to \(task)"
  ))
}
