//  Represents a Model's Details
import Foundation

public struct Model: Equatable, Codable {
  public struct ID: Identifier {
    public let value: String
    public init(value: String) {
      self.value = value
    }
  }
  
  public let id: Model.ID
  public let created: Date
  public let ownedBy: String
  public let permissions: [Model.Permission]
  public let root: Model.ID
  public let parent: Model.ID?
  
  public init(id: Model.ID, created: Date, ownedBy: String, permissions: [Model.Permission], root: Model.ID, parent: Model.ID?) {
    self.id = id
    self.created = created
    self.ownedBy = ownedBy
    self.permissions = permissions
    self.root = root
    self.parent = parent
  }
}

extension Model {
  public struct Permission: Equatable, Codable {
    public struct ID: Identifier {
      public var value: String
      
      public init(value: String) {
        self.value = value
      }
    }
    
    public let id: Model.Permission.ID
    public let created: Date
    public let allowCreateEngine: Bool
    public let allowSampling: Bool
    public let allowLogprobs: Bool
    public let allowSearchIndices: Bool
    public let allowView: Bool
    public let allowFineTuning: Bool
    public let organization: String
    public let group: String?
    public let isBlocking: Bool
    
    public init(
      id: Model.Permission.ID,
      created: Date,
      allowCreateEngine: Bool = true,
      allowSampling: Bool = true,
      allowLogprobs: Bool = true,
      allowSearchIndices: Bool = true,
      allowView: Bool = true,
      allowFineTuning: Bool = true,
      organization: String,
      group: String? = nil,
      isBlocking: Bool = false
    ) {
      self.id = id
      self.created = created
      self.allowCreateEngine = allowCreateEngine
      self.allowSampling = allowSampling
      self.allowLogprobs = allowLogprobs
      self.allowSearchIndices = allowSearchIndices
      self.allowView = allowView
      self.allowFineTuning = allowFineTuning
      self.organization = organization
      self.group = group
      self.isBlocking = isBlocking
    }
  }
}
