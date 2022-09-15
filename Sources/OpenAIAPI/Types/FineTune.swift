import Foundation

/// Represents a `fine-tune`, which may be in progress or complete.
public struct FineTune: JSONResponse {
  
  public let id: ID

  public let model: Model
  
  public let fineTunedModel: OpenAIAPI.Model.ID?
  
  public let createdAt: Date
  
  public let events: [Event]?
  
  public let hyperparams: Hyperparams
  
  public let organizationId: String
  
  public let resultFiles: [File]
  
  public let status: String
  
  public let validationFiles: [File]
  
  public let trainingFiles: [File]
  
  public let updatedAt: Date
  
  public init(id: ID, model: Model, createdAt: Date, events: [Event]?, fineTunedModel: OpenAIAPI.Model.ID?, hyperparams: Hyperparams, organizationId: String, resultFiles: [File], status: String, validationFiles: [File], trainingFiles: [File], updatedAt: Date) {
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
  /// A unique ID for a ``FineTune``.
  public struct ID: Identifier {
    public let value: String
    
    public init(_ value: String) {
      self.value = value
    }
  }
  
  /// Options for fine tune models.
  public enum Model: RawRepresentable, Equatable, Codable, CustomStringConvertible {
    case ada
    case babbage
    case curie
    case davinci
    case fineTuned(_ id: OpenAIAPI.Model.ID)

    public typealias RawValue = String

    public init?(rawValue: String) {
      switch rawValue {
      case "ada": self = .ada
      case "babbage": self = .babbage
      case "curie": self = .curie
      case "davinci": self = .davinci
      default:
        let id = OpenAIAPI.Model.ID(rawValue)
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
  
  public struct Event: Equatable, Codable {
    public let createdAt: Date
    public let level: String
    public let message: String
  }
  
  public struct Hyperparams: Equatable, Codable {
    public let batchSize: Int
    public let learningRateMultiplier: Double
    public let nEpochs: Int
    public let promptLossWeight: Double
  }
}
