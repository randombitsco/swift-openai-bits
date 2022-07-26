import OpenAIGPT3

func printUsage(_ usage: Usage) {
  print("(Usage: Prompt: \(usage.promptTokens); Completion: \(usage.completionTokens); Total: \(usage.totalTokens))")
}
