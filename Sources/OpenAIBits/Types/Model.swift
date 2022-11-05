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
    
    /// Can an engine be created from this model?
    ///
    /// - Note: Sampling is deprecated. Use ``allowFineTuning`` instead.
    @available(*, deprecated, message: "Use allowFineTuning instead")
    public let allowCreateEngine: Bool
    
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
    ///   - allowCreateEngine: Does it ``allowCreateEngine``?
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
      allowCreateEngine: Bool = false,
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
  
  public var supportsEmbedding: Bool { id.supportsEmbedding }
  
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
  
  public var supportsEmbedding: Bool {
    supportsTextSimilarity || supportsTextSearch || supportsCodeSearch
  }
  
  /// Indicates if the model is a `fine-tune` of another model.
  public var isFineTune: Bool {
    return value.contains(":ft-")
  }
}

// MARK: Common Model IDs.

extension Model.ID {
  /// Most capable GPT-3 model. Can do any task the other models can do, often with less context. In addition to responding to ``Completions``, also supports [inserting](https://beta.openai.com/docs/guides/completion/inserting-text) completions within text.
  ///
  /// - Max Tokens: 4,000
  /// - Training Data: Up to Jun 2021
  public static var text_davinci_002: Self { "text-davinci-002" }
  
  /// Very capable, but faster and lower cost than `Davinci`.
  ///
  /// - Max Tokens: 2,048
  /// - Training Data: Up to Oct 2019
  public static var text_curie_001: Self { "text-curie-001" }
  
  /// Capable of straightforward tasks, very fast, and lower cost.
  ///
  /// - Max Tokens: 2,048
  /// - Training Data: Up to Oct 2019
  public static var text_babbage_001: Self { "text-babbage-001" }
  
  /// Capable of very simple tasks, usually the fastest model in the GPT-3 series, and lowest cost.
  ///
  /// - Max Tokens: 2,048
  /// - Training Data: Up to Oct 2019
  public static var text_ada_001: Self { "text-ada-001" }
  
  /// A variation of the `Davinci` model for use with ``Edits``.
  public static var text_davinci_edit_001: Self { "text-davinci-edit-001" }
  
  /// A code-focused variation of the `Davinci` model for use with ``Edits``.
  public static var code_davinci_edit_001: Self { "code-davinci-edit-001" }
  
  /// Most capable Codex model. Particularly good at translating natural language to code. In addition to completing code, also supports inserting completions within code.
  ///
  /// - Max Tokens: 8,000
  /// - Training Data: Up to Jun 2021
  ///
  /// - Note: Currently in Private beta.
  public static var code_davinci_001: Self {  "code-davinci-001" }
  
  /// Almost as capable as Davinci Codex, but slightly faster. This speed advantage may make it preferable for real-time applications.
  ///
  /// - Max Tokens: 2,048
  /// - Training Data: Unknown
  ///
  /// - Note: Currently in Private beta.
  public static var code_cushman_001: Self { "code-cushman-001" }
}
