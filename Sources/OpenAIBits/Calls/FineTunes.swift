import Foundation

/// Contains calls relating to listing, creating, and monitoring fine-tune jobs.
public enum FineTunes {}

extension FineTunes {
  /// Call this to retrieve a list of the organization's fine-tuning jobs.
  public struct List: GetCall {
    public var path: String { "fine-tunes" }
    
    public typealias Response = ListOf<FineTune>
    
    public init() {}
  }
}

extension FineTunes {
  /// Call this to create a new fine-tune job.
  public struct Create: JSONPostCall {
    public var path: String { "fine-tunes" }
    
    public typealias Response = FineTune
    
    public let trainingFile: File.ID
    
    public let validationFile: File.ID?
    
    public let model: FineTune.Model?
    
    public let nEpochs: Int?
    
    public let batchSize: Int?
    
    public let learningRateMultiplier: Double?
    
    public let promptLossWeight: Double?
    
    public let computeClassificationMetrics: Bool?
    
    public let classificationNClasses: Int?
    
    public let classificationPositiveClass: String?
    
    public let classificationBetas: [Double]?
    
    public let suffix: String?
    
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
  /// Call this to get the details of a `fine-tune` job.
  public struct Detail: GetCall {
    public var path: String { "fine-tunes/\(id)" }
    
    public typealias Response = FineTune
    
    public let id: FineTune.ID
    
    public init(id: FineTune.ID) {
      self.id = id
    }
  }
}

extension FineTunes {
  /// Call this to immediately cancel a `fine-tune` job.
  public struct Cancel: BarePostCall {
    public var path: String { "fine-tunes/\(id)/cancel" }
    
    public typealias Response = FineTune
    
    public let id: FineTune.ID
    
    public init(id: FineTune.ID) {
      self.id = id
    }
  }
}

extension FineTunes {
  /// Call this to get a list of ``FineTune.Events`` for a given ``FineTune``.
  /// TODO: Add support for streaming events.
  public struct Events: GetCall {
    public var path: String { "fine-tunes/\(id)/events" }
    
    public typealias Response = ListOf<FineTune.Event>
    
    public let id: FineTune.ID
    
    public init(id: FineTune.ID) {
      self.id = id
    }
  }
}

extension FineTunes {
  /// Deletes a fine-tuned model. You must have the `Owner` role in your organization.
  public struct Delete: DeleteCall {
    public var path: String { "models/\(id)" }
    
    public struct Response: JSONResponse {
      public let id: Model.ID
      public let deleted: Bool
      
      public init(id: Model.ID, deleted: Bool) {
        self.id = id
        self.deleted = deleted
      }
    }
    
    public let id: Model.ID
    
    public init(id: Model.ID) {
      self.id = id
    }
  }
}
