import Foundation

/// Describes a trained model.
public struct Model: Identifiable, JSONResponse, Equatable {
  /// The `ID` for a ``Model``.
  public struct ID: Identifier {
    /// The actual value.
    public let value: String
    
    /// Creates a new ``Model`` `ID`.
    /// - Parameter value: The `ID` value.
    public init(_ value: String) {
      self.value = value
    }
  }
  
  /// The unique ``Model/ID-swift.struct``.
  public let id: Model.ID
  
  /// The creation date.
  public let created: Date
  
  /// The owner ID.
  public let ownedBy: String
  
  /// The list of ``Model/Permission-swift.struct``s for the ``Model``.
  public let permission: [Model.Permission]
  
  /// The root ``Model/ID-swift.struct``.
  public let root: Model.ID
  
  /// The parent ``Model/ID-swift.struct``.
  public let parent: Model.ID?
  
  /// Constructs a ``Model``.
  ///
  /// - Parameters:
  ///   - id: The ``ID-swift.struct``.
  ///   - created: The ``created`` date.
  ///   - ownedBy: The ``ownedBy`` ID.
  ///   - permission: The ``permission-swift.property`` list.
  ///   - root: The ``root`` ID.
  ///   - parent: The ``parent`` ID.
  public init(
    id: Model.ID,
    created: Date,
    ownedBy: String,
    permission: [Model.Permission],
    root: Model.ID,
    parent: Model.ID? = nil
  ) {
    self.id = id
    self.created = created
    self.ownedBy = ownedBy
    self.permission = permission
    self.root = root
    self.parent = parent
  }
}

extension Model {
  /// Describes ther permissions allowed for a model.
  public struct Permission: Identifiable, Equatable, Codable {
    /// The unique `ID` for the ``Model/Permission-swift.struct``.
    public struct ID: Identifier {
      public var value: String
      
      public init(_ value: String) {
        self.value = value
      }
    }
    
    /// The unique ``Model/Permission-swift.struct/ID-swift.struct``.
    public let id: Model.Permission.ID
    
    /// The creation date.
    public let created: Date
    
    /// Can the model be used for sampling?
    public let allowSampling: Bool
    
    /// Does it support outputting logprobs?
    public let allowLogprobs: Bool
    
    /// Does it allow search indices?
    public let allowSearchIndices: Bool
    
    /// Does it allow viewing?
    public let allowView: Bool
    
    /// Does it allow fine-tuning?
    public let allowFineTuning: Bool
    
    /// What organisations do the permissions apply to?
    public let organization: String
    
    /// What group owns the engine?
    public let group: String?
    
    /// Is it currently blocking?
    public let isBlocking: Bool
    
    /// Constructs permissions.
    ///
    /// - Parameters:
    ///   - id: The ``Model/Permission-swift.struct/ID-swift.struct``.
    ///   - created: The ``created`` date.
    ///   - allowSampling: Does it ``allowSampling``?
    ///   - allowLogprobs: Does it ``allowLogprobs``?
    ///   - allowSearchIndices: Does it ``allowSearchIndices``?
    ///   - allowView: Does it ``allowView``?
    ///   - allowFineTuning: Does it ``allowFineTuning``?
    ///   - organization: What organizations can use it?
    ///   - group: What group owns it?
    ///   - isBlocking: Check if it ``isBlocking``.
    public init(
      id: Model.Permission.ID,
      created: Date,
      allowSampling: Bool = false,
      allowLogprobs: Bool = false,
      allowSearchIndices: Bool = false,
      allowView: Bool = false,
      allowFineTuning: Bool = false,
      organization: String,
      group: String? = nil,
      isBlocking: Bool = false
    ) {
      self.id = id
      self.created = created
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
  
  /// Indicates if the model was trained for working with code.
  public var supportsCode: Bool {
    return id.supportsCode
  }
  
  /// Indicates if the model was trained to work with the `/v1/edits` feature.
  public var supportsEdit: Bool {
    return id.supportsEdit
  }
  
  /// Indicates if the model supports text similarty.
  public var supportsTextSimilarity: Bool { id.supportsTextSimilarity }
  
  /// Indicates if the model supports text search.
  public var supportsTextSearch: Bool { id.supportsTextSearch }
  
  /// Indicates if the model supports code search.
  public var supportsCodeSearch: Bool { id.supportsCodeSearch }
  
  public var supportsEmbeddings: Bool { id.supportsEmbeddings }
  
  public var isFineTune: Bool {
    return id.isFineTune
  }

}

// Common Models:
extension Model.ID {
  /// Indicates if the model was trained for working with code.
  public var supportsCode: Bool { value.hasPrefix("code-") }
  
  /// Indicates if the model was trained to work with the `/v1/edits` feature.
  public var supportsEdit: Bool { value.contains("-edit-") }
  
  /// Indicates if the model supports text similarty.
  public var supportsTextSimilarity: Bool { value.starts(with: "text-similarity-") }
  
  /// Indicates if the model supports text search.
  public var supportsTextSearch: Bool { value.starts(with: "text-search-") }
  
  /// Indicates if the model supports code search.
  public var supportsCodeSearch: Bool { value.starts(with: "code-search-") }
  
  public var supportsEmbeddings: Bool {
    value.starts(with: "text-embedding-") || supportsTextSimilarity || supportsTextSearch || supportsCodeSearch
  }
  
  /// Indicates if the model is a `fine-tune` of another model.
  public var isFineTune: Bool {
    return value.contains(":ft-")
  }

  /// Indicates if the model supports audio transcription/translation.
  public var supportsAudio: Bool { value.starts(with: "whisper-") }
}
