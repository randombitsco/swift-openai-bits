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

Basic useage requires importing `OpenAIBits`, and setting up an `OpenAI` instance, with an OpenAI API Key (and Organization Key, if relevant):

```swift
import OpenAIBits

let apiKey: String // your API key. Don't store this in code!
let openai = OpenAI(apiKey: apiKey)

// send a request to the API
let result = try await openai.call(...)
```

## Completions

Completions are the core text generation call. Keep in mind it will use tokens from your account on every call. More information [here](https://beta.openai.com/docs/guides/completion/text-completion).

```swift
let result: Completion = try await openai.call(Completions.Create(
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

Edits allow you to provide a starting `input` and a an `instruction`, and it will return a new result based on the input, modified according to the instruction. More information [here](https://beta.openai.com/docs/guides/completion/editing-text).

```swift
let result: Edit = try await openai.call(Edits.Create(
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

## Embeddings

An embedding is a special format of data representation that can be easily utilized by machine learning models and algorithms. More information [here](https://beta.openai.com/docs/guides/embeddings/embeddings).

```swift
let result: Embedding = try await openai.call(Embeddings.Create(
  model: "text-search-curie-query-001",
  input: "Make an embedding of this.",
  user: "jblogs"
))

let embedding: [Decimal]? = result.first?.embedding
```

## Files

Files can be uploaded to perform other tasks, or results of other task downloaded. More information [here](https://beta.openai.com/docs/api-reference/files).

There are several files operations available (check API documentation for details).

### Upload

Currently, the only official upload purpose is "fine-tune", although there are options for more deprecated options such as "search".

```swift
let fileUrl = URL(fileURLWithPath: "my-training.jsonl")
let file = try await openai.call(Files.Upload(
  filename: "my-training.jsonl",
  purpose: .fineTune,
  url: fileUrl
))

print("File ID: \(file.id)")
```

### List

A list of all files attached to the organization, including both uploaded and generated files.

```swift
let files: ListOf<File> = try await openai.call(Files.List())

for each file in files {
  print("ID: \(file.id), Filename: \(file.filename)")
}
```

### Details

Details of any file ID.

```swift
let file: File = try await openai.call(Files.Detail(id: fileId)
print("Filename: \(file.filename), size: \(file.bytes) bytes")
```

### Content

Downloading requires a file ID, which can be retrieved from the list.

```swift
let response: BinaryResponse = try await openai.call(Files.Content(
  id: file.id
))
print("filename: \(response.filename), size: \(response.data.count) bytes")
```

### Delete

Delete a file permanently.

```swift
let result: Files.Delete.Response = try await openai.call(Files.Delete(
  id: fileToDelete
))
print("File ID: \(response.id), deleted: \(response.deleted)")
```

## Fine-Tunes

It is possible to fine-tune some models with additional details specific to your application. More details [here](https://beta.openai.com/docs/guides/fine-tuning/fine-tuning).

There are several calls related to fine-tuning.

### Create



## Tokens

Along side the `OpenAI` is the `TokenEncoder`. It is a `struct` that can be used and reused, with two methods: `encode(text:)` and `decode(tokens:)`.

```swift
let encoder = TokenEncoder()
let tokens: [Token] = encoder.encoder(text: "A sentence.")
let text: String = encoder.decode(tokens: tokens)

print("Tokens: \(tokens)") // Tokens: [32, 6827, 13]
print("Text: \(text)")     // Text: A sentence.
```

You can also use the `Tokens.Encode` and `Tokens.Decode` `Call`s which can be sent to a `OpenAI`, if you prefer. All processing is done locally.

```swift
let openai = OpenAI(apiKey: ...)
let tokens: [Token] = try await openai.call(Tokens.Encode("A sentence."))
let text: String = try await openai.call(Tokens.Decode(tokens))

print("Tokens: \(tokens)") // Tokens: [32, 6827, 13]
print("Text: \(text)")     // Text: A sentence.
```
