# swift-openai-bits

Provides a Swift library to interact with the [OpenAI](https://openai.com) [GPT-3](https://beta.openai.com/) service.

Best efforts are done to keep it up-to-date with the full API. Class, function and variable names generally follow the conventions of the API, with some modifications made where the API is inconsistent (eg. where the "creation date" is sometimes `created` and sometimes `createdAt`, this library uses `created` for all of them.)

This library provides an `async/await` API for access, so requires being compiled with Swift 5.6+.

# Requirements

## Tools:

- Swift 5.6+
- Xcode 13+

## Operating Systems

- macOS 12 or later
- iOS 15 or later
- tvOS 15 or later
- watchOS 8 or later

# Installation

Add this to your project with Swift Package Manager.

## Xcode

1. Add a package via the `Project` > `[Your Project]` > `Package Dependencies`
2. Enter `https://github.com/randombitsco/swift-openai-bits` for the URL
3. Select `Up to next major version` with the current version value, or select `Branch:` and specify `main`.
4. When prompted, add the `OpenAIBits` target to your project.

## Swift Package Manager

1. Open the `Package.swift` file.
2. Add the following to in the `Package`:
  ```swift
  dependencies: [
    .package(url: "https://github.com/randombitsco/swift-openai-bits", from: "0.0.8"),
  ],
  ```
3. In `targets`, add a dependency on the library to the relevant target:
  ```swift
  .target(
    name: "MyTarget",
    dependencies: [
      .product(name: "OpenAIBits", package: "swift-openai-bits"),
    ]),
  ```

# Usage

Basic useage requires importing `OpenAIBits`, and setting up a `Client` instance, with an OpenAI API Key (and Organization key, if relevant):

```swift
import OpenAIBits

let apiKey: String // your API key. Don't store this in code!
let client = Client(apiKey: apiKey)

// send a request to the API
let result = try await client.call(...)
```

## Completions

Completions are the core text generation call. Keep in mind it will use tokens from your account on every call.

```swift
let result = try await client.call(Completions.Create(
  model: .text_davinci_002,
  prompt: "You complete",
  maxTokens: 50,
  temperature: 0.8
))

let choice = result.choices.first!
print("Completion: \(choice.text)")
print("[Used \(result.usage.totalTokens") tokens]")
```

## Edits

Edits allow you to provide a starting `input` and a an `instruction`, and it will return a new result based on the input, modified according to the instruction.

```swift
let result = try await client.call(Edits.Create(
  model: .text_davinci_002,
  input: """
  We is going to the market.
  """,
  instruction: "Fix the grammar."
))

let choice = result.choices.first!
print("Edit: \(choice.text)")
print("[Used \(result.usage.totalTokens") tokens]")
```

## Tokens

Along side the `Client` is the `TokenEncoder`. It is a `struct` that can be used and reused, with two methods: `encode(text:)` and `decode(tokens:)`.

```swift
let encoder = TokenEncoder()
let tokens: [Int] = encoder.encoder(text: "A sentence.")
let text: String = encoder.decode(tokens: tokens)

print("Tokens: \(tokens)") // Tokens: [32, 6827, 13]
print("Text: \(text)")     // Text: A sentence.
```

You can also use the `Tokens.Encode` and `Tokens.Decode` `Call`s which can be sent to a `Client`, if you prefer. They do not send anything over the internet either way.

```swift
let client = Client(apiKey: ...)
let tokens = try await client.call(Tokens.Encode("A sentence."))
let text = try await client.call(Tokens.Decode(tokens))

print("Tokens: \(tokens)") // Tokens: [32, 6827, 13]
print("Text: \(text)")     // Text: A sentence.
```

