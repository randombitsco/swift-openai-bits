# swift-openai-gpt3

Provides a Swift library to interact with the [OpenAI](https://openai.com) [GPT-3](https://beta.openai.com/) service.

This library provides an `async/await` API for access.

## Requirements

- macOS 12 or later
- iOS 15 or later
- tvOS 15 or later
- watchOS 8 or later

## Installation

Add this to your project with Swift Package Manager.

### Xcode

1. Add a package via the `Project` > `[Your Project]` > `Package Dependencies`
2. Enter `https://github.com/randombitsco/swift-openai-api` for the URL
3. Select `Up to next major version` with the current version value, or select `Branch:` and specify `main`.
4. When prompted, add the `OpenAIAPI` target to your project.

### Swift Package Manager

1. Open the `Project.swift` file.
2. Add the following to `dependencies`:
  ```swift
  .package(url: "https://github.com/randombitsco/swift-openai-api", from: "0.0.8"),
  ```
3. In `targets`, add a dependency on the library to the relevant target:
  ```swift
  dependencies: [
    .product(name: OpenAIAPI, package: "swift-openai-api"),
  ],
  ```

## Usage

Basic useage requires setting up a `Client` instance, with an OpenAI API Key (and Organization key, if relevant):

```swift
import OpenAIAPI

let apiKey: String // your API key. Don't store this in code!
let client = Client(apiKey: apiKey)

let result = try await client.call(...) // pass in a call and
```

### Completions

Completions are the core text generation call. Keep in mind it will use tokens from your account on every call.

```swift
let result = try await client.call(Completions(
  model: .text_davinci_002,
  prompt: "You complete",
  maxTokens: 50,
  temperature: 0.8,
  n: 1
))

let choice = result.choices.first!
print("Completion: \(choice.text)")
print("[Used \(result.usage.totalTokens") tokens]")
```
