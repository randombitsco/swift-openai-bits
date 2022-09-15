import ArgumentParser
import OpenAIAPI

struct FineTunesCommand: AsyncParsableCommand {
  static var configuration = CommandConfiguration(
    commandName: "fine-tunes",
    abstract: "Commands relating to listing, creating, and managing fine-tuning models.",
    
    subcommands: [
      FineTunesListCommand.self,
      FineTunesCreateCommand.self,
      FineTunesDetailCommand.self,
      FineTunesCancelCommand.self,
      FineTunesDeleteCommand.self,
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

struct FineTunesCreateCommand: AsyncParsableCommand {
  static var configuration = CommandConfiguration(
    commandName: "create",
    abstract: "Creates a job that fine-tunes a specified model from a given dataset."
  )
  
  @Option(help: """
  The ID of an uploaded file that contains training data.
  Your dataset must be formatted as a JSONL file, where each training example is a JSON object with the keys "prompt" and "completion". Additionally, you must upload your file with the purpose `fine-tune`.
  """)
  public var trainingFile: File.ID
  
  @Option(help: """
  The ID of an uploaded file that contains validation data.

  If you provide this file, the data is used to generate validation metrics periodically during fine-tuning. These metrics can be viewed in the fine-tuning results file. Your train and validation data should be mutually exclusive.

  Your dataset must be formatted as a JSONL file, where each validation example is a JSON object with the keys "prompt" and "completion". Additionally, you must upload your file with the purpose `fine-tune`.
  """)
  public var validationFile: File.ID?
  
  @Option(help: """
  The name of the base model to fine-tune. You can select one of "ada", "babbage", "curie", "davinci", or a fine-tuned model created after 2022-04-21. (defaults to "curie")
  """)
  public var model: FineTune.Model?
  
  @Option(help: """
  The number of epochs to train the model for. An epoch refers to one full cycle through the training dataset. (defaults to 4).
  """)
  public var nEpochs: Int?
  
  @Option(help: """
  The batch size to use for training. The batch size is the number of training examples used to train a single forward and backward pass.
  
  By default, the batch size will be dynamically configured to be ~0.2% of the number of examples in the training set, capped at 256 - in general, we've found that larger batch sizes tend to work better for larger datasets.
  """)
  public var batchSize: Int?
  
  @Option(help: """
  The learning rate multiplier to use for training. The fine-tuning learning rate is the original learning rate used for pretraining multiplied by this value.

  By default, the learning rate multiplier is the 0.05, 0.1, or 0.2 depending on final batch_size (larger learning rates tend to perform better with larger batch sizes). We recommend experimenting with values in the range 0.02 to 0.2 to see what produces the best results.
  """)
  public var learningRateMultiplier: Double?
  
  @Option(help: """
  The weight to use for loss on the prompt tokens. This controls how much the model tries to learn to generate the prompt (as compared to the completion which always has a weight of 1.0), and can add a stabilizing effect to training when completions are short.

  If prompts are extremely long (relative to completions), it may make sense to reduce this weight so as to avoid over-prioritizing learning the prompt.
  """)
  public var promptLossWeight: Double?
  
  @Option(help: """
  If set, we calculate classification-specific metrics such as accuracy and F-1 score using the validation set at the end of every epoch. These metrics can be viewed in the results file.

  In order to compute classification metrics, you must provide a --validation-file. Additionally, you must specify --classification-n-classes for multiclass classification or --classification-positive-class for binary classification.
  """)
  public var computeClassificationMetrics: Bool?
  
  @Option(help: """
  The number of classes in a classification task. This parameter is required for multiclass classification.
  """)
  public var classificationNClasses: Int?
  
  @Option(help: """
  The positive class in binary classification.

  This parameter is needed to generate precision, recall, and F1 metrics when doing binary classification.
  """)
  public var classificationPositiveClass: String?
  
  @Option(help: """
  If this is provided, we calculate F-beta scores at the specified beta values. The F-beta score is a generalization of F-1 score. This is only used for binary classification.

  With a beta of 1 (i.e. the F-1 score), precision and recall are given the same weight. A larger beta score puts more weight on recall and less on precision. A smaller beta score puts more weight on precision and less on recall.
  """)
  public var classificationBetas: [Double] = []
  
  @Option(help: """
  A string of up to 40 characters that will be added to your fine-tuned model name.

  For example, a suffix of "custom-model-name" would produce a model name like "ada:ft-your-org:custom-model-name-2022-02-15-04-21-04".
  """)
  public var suffix: String?
  
  @OptionGroup var config: Config
  
  mutating func validate() throws {
    if computeClassificationMetrics == true && validationFile == nil {
      throw ValidationError("If computing classification metrics you must provide a validation file.")
    }
  }

  mutating func run() async throws {
    let client = config.client()
    
    let results = try await client.call(FineTunes.Create(
      trainingFile: trainingFile, validationFile: validationFile,
      model: model, nEpochs: nEpochs, batchSize: batchSize,
      learningRateMultiplier: learningRateMultiplier, promptLossWeight: promptLossWeight,
      computeClassificationMetrics: computeClassificationMetrics,
      classificationNClasses: classificationNClasses,
      classificationPositiveClass: classificationPositiveClass,
      classificationBetas: classificationBetas.isEmpty ? nil : classificationBetas,
      suffix: suffix
    ))
    
    let format = config.format()
    print(title: "Fine-Tune Created", format: format)
    print(fineTune: results, format: format)
  }
}

struct FineTunesDetailCommand: AsyncParsableCommand {
  static var configuration = CommandConfiguration(
    commandName: "detail",
    abstract: "Gets info about the fine-tune job."
  )
  
  @Option(help: "The ID of the fine-tune job.")
  var fineTuneId: FineTune.ID
  
  @OptionGroup var config: Config
  
  mutating func run() async throws {
    let client = config.client()
    
    let result = try await client.call(FineTunes.Details(id: fineTuneId))
    
    let format = config.format()
    print(title: "Fine-Tune Detail", format: format)
    print(fineTune: result, format: format)
  }
}

struct FineTunesCancelCommand: AsyncParsableCommand {
  static var configuration = CommandConfiguration(
    commandName: "cancel",
    abstract: "Immediately cancel a fine-tune job."
  )
  
  @Option(help: "The ID of the fine-tune job to cancel.")
  var fineTuneId: FineTune.ID
  
  @OptionGroup var config: Config
  
  mutating func run() async throws {
    let client = config.client()
    
    let result = try await client.call(FineTunes.Cancel(id: fineTuneId))
    
    let format = config.format()
    print(title: "Fine-Tune Cancelled", format: format)
    print(fineTune: result, format: format)
  }
}

struct FineTunesEventsCommand: AsyncParsableCommand {
  static var configuration = CommandConfiguration(
    commandName: "events",
    abstract: "Get fine-grained status updates for a fine-tune job."
  )
  
  @Option(help: "The ID of the fine-tune job to get events for.")
  var fineTuneId: FineTune.ID
  
  @OptionGroup var config: Config
  
  mutating func run() async throws {
    let client = config.client()
    
    let result = try await client.call(FineTunes.Events(id: fineTuneId))
    
    let format = config.format()
    print(title: "Fine-Tune Events", format: format)
    print(list: result.data, label: "Event", format: format, with: print(event:format:))
  }
}

struct FineTunesDeleteCommand: AsyncParsableCommand {
  static var configuration = CommandConfiguration(
    commandName: "delete",
    abstract: "Delete a fine-tuned model. You must have the Owner role in your organization."
  )
  
  @Option(help: "The fine-tuned model to delete.")
  var modelId: Model.ID
  
  @OptionGroup var config: Config
  
  mutating func run() async throws {
    let client = config.client()
    
    let result = try await client.call(FineTunes.Delete(id: modelId))
    
    let format = config.format()
    print(title: "Fine-Tune Deleted", format: format)
    print(label: "ID", value: result.id, format: format)
    print(label: "Deleted", value: result.deleted ? "yes" : "no", format: format)
  }
}

// MARK: ExpressibleByArgument

extension FineTune.ID: ExpressibleByArgument {
  public init?(argument: String) {
    self.init(argument)
  }
}
extension FineTune.Model: ExpressibleByArgument {}
