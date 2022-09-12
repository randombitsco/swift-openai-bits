import OpenAIAPI

func printUsage(_ usage: Usage) {
  print("(Token Usage: Prompt: \(usage.promptTokens); Completion: \(usage.completionTokens); Total: \(usage.totalTokens))")
}
