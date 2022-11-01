import Foundation

/// Represents a ``FineTune`` job, which may be in progress or complete. See ``FineTunes`` for details.
///
/// ## Related Calls
///
/// - ``FineTunes/Create``
/// - ``FineTunes/List``
/// - ``FineTunes/Detail``
/// - ``FineTunes/Cancel``
/// - ``FineTunes/Delete``
///
/// ## See Also
///
/// - [OpenAI API](https://beta.openai.com/docs/api-reference/fine-tunes)
/// - [Fine-tuning guide](https://beta.openai.com/docs/guides/fine-tuning)
public struct FineTune: Identifiable, JSONResponse {
  /// A unique ID for a ``FineTune`` job.
  public struct ID: Identifier {
    public let value: String
    
    public init(_ value: String) {
      self.value = value
    }
  }
  
  /// The ``FineTune/ID-swift.struct`` for the fine-tune job.
  public let id: ID

  /// The original ``FineTune/Model-swift.enum`` being fine-tuned.
  public let model: Model
  
  /// The ``OpenAIBits/Model/ID-swift.struct`` of the resulting fine-tuned ``Model``.
  public let fineTunedModel: OpenAIBits.Model.ID?
  
  /// The creation date.
  public let createdAt: Date
  
  /// The list of ``Event``s related to the job.
  public let events: [Event]?
  
  /// The ``Hyperparams-swift.struct``
  public let hyperparams: Hyperparams
  
  /// The owning organization ID.
  public let organizationId: String
  
  /// The list of ``File``s that resulted from the job.
  public let resultFiles: [File]
  
  /// The current status.
  public let status: String
  
  /// The list of ``File``s used for validation of the training.
  public let validationFiles: [File]
  
  /// The list of ``File``s used for training.
  public let trainingFiles: [File]
  
  /// The last update date.
  public let updatedAt: Date
  
  /// Constructs a `fine-tune` job description.
  ///
  /// - Parameters:
  ///   - id: The unique ``FineTune/ID-swift.struct``.
  ///   - model: The ``Model-swift.enum`` being fine-tuned.
  ///   - createdAt: The creation date.
  ///   - events: The list of ``Event``s.
  ///   - fineTunedModel: The ``Model/ID-swift.struct`` of the resulting fine-tuned ``Model``.
  ///   - hyperparams: The ``Hyperparams-swift.struct``.
  ///   - organizationId: The owning organization ID.
  ///   - resultFiles: The list of ``File``s that resulted from the job.
  ///   - status: The current status.
  ///   - validationFiles: The list of ``File``s used for validation of the training.
  ///   - trainingFiles: The list of ``File``s used for training.
  ///   - updatedAt: The last update date.
  public init(id: ID, model: Model, createdAt: Date, events: [Event]?, fineTunedModel: OpenAIBits.Model.ID?, hyperparams: Hyperparams, organizationId: String, resultFiles: [File], status: String, validationFiles: [File], trainingFiles: [File], updatedAt: Date) {
    self.id = id
    self.model = model
    self.createdAt = createdAt
    self.events = events
    self.fineTunedModel = fineTunedModel
    self.hyperparams = hyperparams
    self.organizationId = organizationId
    self.resultFiles = resultFiles
    self.status = status
    self.validationFiles = validationFiles
    self.trainingFiles = trainingFiles
    self.updatedAt = updatedAt
  }
}

extension FineTune {
  /// Options for fine tune models.
  public enum Model: RawRepresentable, Equatable, Codable, CustomStringConvertible {
    /// The `Ada` model.
    case ada
    
    /// The `Babbage` model.
    case babbage
    
    /// The `Curie` model.
    case curie
    
    /// The `Davindi` model.
    case davinci
    
    /// Another fine-tuned ``OpenAIBits/Model``.
    case fineTuned(_ id: OpenAIBits.Model.ID)
    
    public init?(rawValue: String) {
      switch rawValue {
      case "ada": self = .ada
      case "babbage": self = .babbage
      case "curie": self = .curie
      case "davinci": self = .davinci
      default:
        let id = OpenAIBits.Model.ID(rawValue)
        if id.isFineTune {
          self = .fineTuned(id)
        } else {
          return nil
        }
      }
    }
    
    public var rawValue: String {
      switch self {
      case .ada: return "ada"
      case .babbage: return "babbage"
      case .curie: return "curie"
      case .davinci: return "davinci"
      case .fineTuned(let id):
        return id.value
      }
    }
    
    public var description: String { rawValue }
  }
}

extension FineTune {
  /// Event
  public struct Event: Equatable, Codable {
    public let createdAt: Date
    public let level: String
    public let message: String
  }
}

extension FineTune {
  /// Details about the training parameters.
  public struct Hyperparams: Equatable, Codable {
    /// The number of epochs to train the model for. An epoch refers to one full cycle through the training dataset.
    public let nEpochs: Int
    
    /// The batch size to use for training. The batch size is the number of training examples used to train a single forward and backward pass.
    ///
    /// By default, the batch size will be dynamically configured to be ~0.2% of the number of examples in the training set, capped at `256` - in general, we've found that larger batch sizes tend to work better for larger datasets.
    public let batchSize: Int
    
    /// The learning rate multiplier to use for training. The fine-tuning learning rate is the original learning rate used for pretraining multiplied by this value.
    ///
    /// By default, the learning rate multiplier is the 0.05, 0.1, or 0.2 depending on final batch_size (larger learning rates tend to perform better with larger batch sizes). We recommend experimenting with values in the range 0.02 to 0.2 to see what produces the best results.
    public let learningRateMultiplier: Double
    
    /// The weight to use for loss on the prompt tokens. This controls how much the model tries to learn to generate the prompt (as compared to the completion which always has a weight of `1.0`), and can add a stabilizing effect to training when completions are short.
    ///
    /// If prompts are extremely long (relative to completions), it may make sense to reduce this weight so as to avoid over-prioritizing learning the prompt.
    public let promptLossWeight: Double
  }
}

extension FineTune {
  /// Represents a ``FineTune`` job status.
  public enum Status: RawRepresentable, Equatable, Codable, CustomStringConvertible {
    /// The job has not yet started.
    case pending
    /// The job succeeded.
    case succeeded
    
    // TODO: Figure out other valid statuses
    
    /// Any other status.
    case other(String)
    
    public var rawValue: String {
      switch self {
      case .pending: return "pending"
      case .succeeded: return "succeeded"
      case .other(let value): return value
      }
    }
    
    public init?(rawValue: String) {
      switch rawValue {
      case "pending": self = .pending
      case "succeeded": self = .succeeded
      default: self = .other(rawValue)
      }
    }
    
    public var description: String { rawValue }
  }
}
