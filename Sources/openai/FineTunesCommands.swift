import ArgumentParser
import OpenAIAPI

struct FineTunesCommand: AsyncParsableCommand {
  static var configuration = CommandConfiguration(
    commandName: "fine-tunes",
    abstract: "Commands relating to listing, creating, and managing fine-tuning models.",
    
    subcommands: [
      FineTunesListCommand.self,
    ]
  )
}

struct FineTunesListCommand: AsyncParsableCommand {
  static var configuration = CommandConfiguration(
    commandName: "list",
    abstract: "Lists the current fine-tuned models."
  )
  
  @OptionGroup var config: Config
  
  mutating func run() async throws {
    let client = config.client()
    
    let result = try await client.call(FineTunes.List())
    
    print(title: "Fine-Tunes", format: config.format())
    print(list: result.data, label: "Fine-Tune", format: config.format(), with: print(fineTune:format:))
  }
}

func print(fineTune: FineTune, format: Format) {
  print(label: "ID", value: fineTune.id, format: format)
  print(label: "Model", value: fineTune.model, format: format)
  print(label: "Fine-Tuned Model", value: fineTune.fineTunedModel, format: format)
  print(label: "Organization", value: fineTune.organizationId, format: format)
  print(label: "Status", value: fineTune.status, format: format)
  print(label: "Created At", value: fineTune.createdAt, format: format)
  print(label: "Updated At", value: fineTune.updatedAt, format: format)
  print(label: "Batch Size", value: fineTune.hyperparams.batchSize, format: format)
  print(label: "Learning Rate Multiplier", value: fineTune.hyperparams.learningRateMultiplier, format: format)
  print(label: "N-Epochs", value: fineTune.hyperparams.nEpochs, format: format)
  print(label: "Prompt Loss Weight", value: fineTune.hyperparams.promptLossWeight, format: format)
  
  if let events = fineTune.events, !events.isEmpty {
    print("")
    print(subtitle: "Events:", format: format)
    for (i, event) in events.enumerated() {
      print(item: event, index: i, format: format.indent(by: 2), with: print(event:format:))
    }
  }
  
  if !fineTune.resultFiles.isEmpty {
    print("")
    print(subtitle: "Result Files:", format: format)
    for (i, file) in fineTune.resultFiles.enumerated() {
      print(item: file, label: "File", index: i, format: format.indent(by: 2), with: print(file:format:))
    }
  }
  
  if !fineTune.validationFiles.isEmpty {
    print("")
    print(subtitle: "Validation Files:", format: format)
    for (i, file) in fineTune.validationFiles.enumerated() {
      print(item: file, label: "File", index: i, format: format.indent(by: 2), with: print(file:format:))
    }
  }
  
  if !fineTune.trainingFiles.isEmpty {
    print("")
    print(subtitle: "Training Files:", format: format)
    for (i, file) in fineTune.trainingFiles.enumerated() {
      print(item: file, label: "File", index: i, format: format.indent(by: 2), with: print(file:format:))
    }
  }
}

func print(event: FineTune.Event, format: Format) {
  print(label: "Created At", value: event.createdAt, format: format)
  print(label: "Level", value: event.level, format: format)
  print(label: "Message", value: event.level, format: format)
}
