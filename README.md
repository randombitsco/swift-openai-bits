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
    .package(url: "https://github.com/randombitsco/swift-openai-bits", from: "1.0.0"),
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

for file in files {
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

You can create a fine-tuning job by first using the `Files.Upload` with a `.fineTune` purpose, then referencing that file ID here:

```swift
let file = try await openai.call(Files.Upload(purpose: .fineTune, url: fileUrl))
let fineTune: FineTune = openai.call(FineTunes.Create(
  trainingFile: file.id,
  model: .davinci
))
print("Fine Tune ID: \(fineTune.id)")
```

### List

Lists all previous fine-tuning jobs.

```swift
let fineTunes: ListOf<FineTune> = try await openai.call(FineTunes.List())

for fineTune in fineTunes {
  print("ID: \(fineTune.id), Status: \(fineTune.status)")
}
```

### Detail

Retrieves the detail for a given fine-tune `ID`.

```swift
let fineTune: FineTune = try await openai.call(FineTunes.Detail(id: someId)
print("Fine Tune ID: \(fineTune.id)")
```

### Cancel

Fine-tune jobs may run for some time. You can cancel them if you wish.

```swift
let fineTune: FineTune = try await openai.call(FineTunes.Cancel(id: someId))
print("Fine Tune Status: \(fineTune.status")
```

### Events

Retrieves just the list of events for a fine-tune job.

```swift
let events: ListOf<FineTune.Event> = try await openai.call(FineTunes.Events(id: someId))
for event in events {
  print("Created: \(event.created), Level: \(event.level), Message: \(event.message)")
}
```

### Delete

Deletes a fine-tuned model.

```swift
let response: FineTunes.Delete.Response = try await openai.call(FineTunes.Delete(id: someId))
print("Model ID: \(response.id), Deleted: \(response.deleted)")
```

## Images

The DALL-E 2 model can be be used to generate, edit, and make variations of images. More details [here](https://beta.openai.com/docs/guides/images).

### Create

This is the core image generator. Provide a text prompt and generate one or more images for it.

```swift
let result: Generations = try await openai.call(Images.Create(
  prompt: "A koala riding a bicycle",
  n: 4,
))
for image in result.images {
  if case let .url(url) = image {
    print("Image URL: \(url)")
  }
}
```

### Edit

You can provide an image, a matching-size PNG with 100% transparent sections, and a prompt to describe what will be generated in the marked sections. It will produce 1-10 options based on the parameters.

```swift
let imageData: Data = ...
let maskData: Data = ...
let result: Generations = try await openai.call(Images.Edit(
  image: imageData,
  mask: maskData,
  prompt: "A space rocket",
  n: 6,
  responseFormat: .data
))
for image in result.images {
  if let .data(data) = image {
    try data.write(to: ...)
  }
}
```

### Variations

You provide an initial image, and it will generate 1 to 10 variations of the original image.

```swift
let imageData: Data = ...
let result: Generations = try await openai.call(Images.Variation(
  image: imageData,
  n: 10,
  size: .of512x512,
  responseFormat: .url
))
for image in result.images {
  if case let .url(url) = image {
    print("Image URL: \(url)")
  }
}
```

## Models

Retrieve information about available models.

### List

Gets a list of all models available to you/your organization, including fine-tuned models.

```swift
let models: ListOf<Model> = try await openai.call(Models.List())
for model in models {
  print("Model ID: \(model.id)")
}
```

### Detail

Gets the details for a specific model.

```swift
let model: Model = try await openai.call(Models.Detail(
  id: .text_davinci_002
))
print("Allow Fine-Tuning: \(model.allowFineTuning)")
```

### Delete

You can delete models created/owned by you, which in most cases will be fine-tuned models.

```swift
let result: Models.Delete.Result = try await openai.call(Models.Delete(id: ...))
print("Deleted \(result.id): \(result.deleted)")
```

## Moderations

OpenAI provides an endpoint to check if text content meets their usage policies. More details [here](https://beta.openai.com/docs/guides/moderation).

### Create

Creates a moderation check.

```swift
let promptValue: String = ...
let moderation: Moderation = try await openai.call(Moderations.Create(
  input: promptValue
))
print("Flagged: \(moderation.results?.first.flagged ?? "false")")
```

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
