import Foundation

/// Manage fine-tuning jobs to tailor a model to your specific training data.
///
/// ## See Also
///
/// - [OpenAI API](https://beta.openai.com/docs/api-reference/fine-tunes)
/// - [Fine-tuning guide](https://beta.openai.com/docs/guides/fine-tuning)
public enum FineTunes {}

extension FineTunes {
  /// Call this to retrieve a list of the organization's fine-tuning jobs.
  ///
  /// ## See Also
  ///
  /// - [OpenAI API](https://beta.openai.com/docs/api-reference/fine-tunes/list)
  public struct List: GetCall {
    var path: String { "fine-tunes" }
    
    /// Responds with a ``ListOf`` ``FineTune``s.
    public typealias Response = ListOf<FineTune>
    
    /// List your organization's fine-tuning jobs.
    public init() {}
  }
}

extension FineTunes {
  /// Creates a job that fine-tunes a specified model from a given dataset.
  ///
  /// Response includes details of the enqueued job including job status and the
  /// name of the fine-tuned models once complete.
  ///
  /// Learn more about Fine-tuning
  ///
  /// ## See Also
  ///
  /// - [OpenAI API](https://beta.openai.com/docs/api-reference/fine-tunes/create)
  /// - [Fine-tuning guide](https://beta.openai.com/docs/guides/fine-tuning)
  public struct Create: JSONPostCall {
    var path: String { "fine-tunes" }
    
    /// Responds with a ``FineTune``.
    public typealias Response = FineTune
    
    /// The ``File/ID-swift.struct`` of an uploaded file that contains training data.
    ///
    /// See [upload file](https://beta.openai.com/docs/api-reference/files/upload) for how to upload a file.
    ///
    /// Your dataset must be formatted as a JSONL file, where each training example is a JSON object with the keys "prompt" and "completion". Additionally, you must upload your file with the purpose fine-tune.
    ///
    /// See the [fine-tuning guide](https://beta.openai.com/docs/guides/fine-tuning/creating-training-data) for more details.
    public let trainingFile: File.ID
    
    /// The ID of an uploaded file that contains validation data.
    ///
    /// If you provide this file, the data is used to generate validation metrics periodically during fine-tuning. These metrics can be viewed in the [fine-tuning results file](https://beta.openai.com/docs/guides/fine-tuning/analyzing-your-fine-tuned-model). Your train and validation data should be mutually exclusive.
    ///
    /// Your dataset must be formatted as a JSONL file, where each validation example is a JSON object with the keys "prompt" and "completion". Additionally, you must ``Files/Upload`` your file with the purpose ``Files/Upload/Purpose-swift.enum``.
    ///
    /// See the [fine-tuning guide](https://beta.openai.com/docs/guides/fine-tuning/creating-training-data) for more details.
    public let validationFile: File.ID?
    
    /// The name of the base ``FineTune/Model-swift.enum`` to fine-tune. You can select one of ``FineTune/Model-swift.enum/ada``, ``FineTune/Model-swift.enum/babbage``, ``FineTune/Model-swift.enum/curie``, ``FineTune/Model-swift.enum/davinci``, or a fine-tuned model created after 2022-04-21. To learn more about these models, see the ``Models`` documentation.
    public let model: FineTune.Model?
    
    /// The number of epochs to train the model for. An epoch refers to one full cycle through the training dataset.
    public let nEpochs: Int?
    
    /// The batch size to use for training. The batch size is the number of training examples used to train a single forward and backward pass.
    ///
    /// By default, the batch size will be dynamically configured to be ~0.2% of the number of examples in the training set, capped at `256`` - in general, we've found that larger batch sizes tend to work better for larger datasets.
    public let batchSize: Int?
    
    /// The learning rate multiplier to use for training. The fine-tuning learning rate is the original learning rate used for pretraining multiplied by this value.
    ///
    /// By default, the learning rate multiplier is the `0.05`, `0.1`, or `0.2` depending on final ``batchSize`` (larger learning rates tend to perform better with larger batch sizes). We recommend experimenting with values in the range `0.02` to `0.2` to see what produces the best results.
    public let learningRateMultiplier: Double?
    
    /// The weight to use for loss on the prompt tokens. This controls how much the model tries to learn to generate the prompt (as compared to the completion which always has a weight of `1.0`), and can add a stabilizing effect to training when completions are short.
    ///
    /// If prompts are extremely long (relative to completions), it may make sense to reduce this weight so as to avoid over-prioritizing learning the prompt.
    ///
    /// Defaults to `0.0`.
    public let promptLossWeight: Double?
    
    /// If set, we calculate classification-specific metrics such as accuracy and F-1 score using the validation set at the end of every epoch. These metrics can be viewed in the [results file](https://beta.openai.com/docs/guides/fine-tuning/analyzing-your-fine-tuned-model).
    ///
    /// In order to compute classification metrics, you must provide a ``validationFile``. Additionally, you must specify ``classificationNClasses`` for multiclass classification or ``classificationPositiveClass`` for binary classification.
    ///
    /// Defaults to `false`.
    public let computeClassificationMetrics: Bool?
    
    /// The number of classes in a classification task.
    ///
    /// This parameter is required for multiclass classification.
    ///
    /// Defaults to `nil`.
    public let classificationNClasses: Int?
    
    /// The positive class in binary classification.
    ///
    /// This parameter is needed to generate precision, recall, and F1 metrics when doing binary classification.
    ///
    /// Defaults to `nil`.
    public let classificationPositiveClass: String?
    
    /// If this is provided, we calculate F-beta scores at the specified beta values. The F-beta score is a generalization of F-1 score. This is only used for binary classification.
    ///
    /// With a beta of `1` (i.e. the F-1 score), precision and recall are given the same weight. A larger beta score puts more weight on recall and less on precision. A smaller beta score puts more weight on precision and less on recall.
    ///
    /// Defaults to `nil`.
    public let classificationBetas: [Double]?
    
    /// A string of up to 40 characters that will be added to your fine-tuned model name.
    ///
    /// For example, a ``suffix`` of `"custom-model-name"` would produce a model name like `ada:ft-your-org:custom-model-name-2022-02-15-04-21-04`.
    ///
    /// Defaults to `nil`.
    public let suffix: String?
    
    /// Creates a job that fine-tunes a specified model from a given dataset.
    ///
    /// Response includes details of the enqueued job including job status and the name of the fine-tuned models once complete.
    ///
    /// - Parameters:
    ///   - trainingFile: The ``trainingFile``.
    ///   - validationFile: The ``validationFile``.
    ///   - model: The ``model``.
    ///   - nEpochs: The ``nEpochs``.
    ///   - batchSize: The ``batchSize``.
    ///   - learningRateMultiplier: The ``learningRateMultiplier``.
    ///   - promptLossWeight: The ``promptLossWeight``.
    ///   - computeClassificationMetrics: The ``computeClassificationMetrics``.
    ///   - classificationNClasses: The ``classificationNClasses``.
    ///   - classificationPositiveClass: The ``classificationPositiveClass``.
    ///   - classificationBetas: The ``classificationBetas``.
    ///   - suffix: The ``suffix``.
    public init(trainingFile: File.ID, validationFile: File.ID?, model: FineTune.Model?, nEpochs: Int?, batchSize: Int?, learningRateMultiplier: Double?, promptLossWeight: Double?, computeClassificationMetrics: Bool?, classificationNClasses: Int?, classificationPositiveClass: String?, classificationBetas: [Double]?, suffix: String?) {
      self.trainingFile = trainingFile
      self.validationFile = validationFile
      self.model = model
      self.nEpochs = nEpochs
      self.batchSize = batchSize
      self.learningRateMultiplier = learningRateMultiplier
      self.promptLossWeight = promptLossWeight
      self.computeClassificationMetrics = computeClassificationMetrics
      self.classificationNClasses = classificationNClasses
      self.classificationPositiveClass = classificationPositiveClass
      self.classificationBetas = classificationBetas
      self.suffix = suffix
    }
  }
}

extension FineTunes {
  /// Gets info about the fine-tune job.
  ///
  /// ## See Also
  ///
  /// - [OpenAI API](https://beta.openai.com/docs/api-reference/fine-tunes/retrieve)
  /// - [Fine-tuning guide](https://beta.openai.com/docs/guides/fine-tuning)
  public struct Detail: GetCall {
    var path: String { "fine-tunes/\(id)" }
    
    /// Responds with a ``FineTune``.
    public typealias Response = FineTune
    
    /// The ``FineTune/ID-swift.struct`` of the fine-tune job.
    public let id: FineTune.ID
    
    /// Gets info about the fine-tune job.
    ///
    /// - Parameter id: The ``FineTune/ID-swift.struct`` of the fine-tune job.
    public init(id: FineTune.ID) {
      self.id = id
    }
  }
}

extension FineTunes {
  /// Immediately cancel a `fine-tune` job.
  public struct Cancel: BarePostCall {
    var path: String { "fine-tunes/\(id)/cancel" }
    
    /// Responds with a ``FineTune``.
    public typealias Response = FineTune
    
    /// The ``FineTune/ID-swift.struct`` of the fine-tune job to cancel.
    public let id: FineTune.ID
    
    /// Immediately cancel a `fine-tune` job.
    ///
    /// - Parameter id: The ``FineTune/ID-swift.struct`` of the fine-tune job to cancel.
    public init(id: FineTune.ID) {
      self.id = id
    }
  }
}

extension FineTunes {
  /// Call this to get a list of ``FineTune/Event``s for a given ``FineTune``.
  ///
  /// TODO: Add support for streaming events.
  ///
  /// ## See Also
  ///
  /// - [OpenAI API](https://beta.openai.com/docs/api-reference/fine-tunes/events)
  public struct Events: GetCall {
    var path: String { "fine-tunes/\(id)/events" }
    
    /// Responds with a ``ListOf`` ``FineTune/Event``s.
    public typealias Response = ListOf<FineTune.Event>
    
    /// The ``FineTune/ID-swift.struct`` of the fine-tune job to get events for.
    public let id: FineTune.ID
    
    /// Call this to get a list of ``FineTune/Event``s for a given ``FineTune``.
    ///
    /// - Parameter id: The ``FineTune/ID-swift.struct`` of the fine-tune job to get events for.
    public init(id: FineTune.ID) {
      self.id = id
    }
  }
}

extension FineTunes {
  /// Delete a fine-tuned model. You must have the `Owner` role in your organization.
  ///
  /// ## See Also
  ///
  /// - [OpenAI API](https://beta.openai.com/docs/api-reference/fine-tunes/delete-model)
  public struct Delete: DeleteCall {
    public var path: String { "models/\(id)" }
    
    /// The ``FineTunes/Delete`` `Response`.
    public struct Response: JSONResponse {
      /// The ``Model/ID-swift.struct`` for the fine-tuned ``Model`` that was deleted.
      public let id: Model.ID

      /// Indicates if it was deleted.
      public let deleted: Bool
      
      /// The ``FineTunes/Delete`` `Response`.
      ///
      /// - Parameter id: The ``Model/ID-swift.struct`` for the fine-tuned ``Model`` that was deleted.
      /// - Parameter deleted: Indicates if it was deleted.
      public init(id: Model.ID, deleted: Bool) {
        self.id = id
        self.deleted = deleted
      }
    }
    
    /// The ``Model/ID-swift.struct`` to delete.
    public let id: Model.ID
    

    /// Delete a fine-tuned model. You must have the `Owner` role in your organization.
    ///
    /// - Parameter id: The ``Model/ID-swift.struct`` to delete.
    public init(id: Model.ID) {
      self.id = id
    }
  }
}
