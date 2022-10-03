//  Represents a Model's Details
import Foundation

public struct Model: JSONResponse, Equatable {
  public struct ID: Identifier {
    public let value: String
    public init(_ value: String) {
      self.value = value
    }
  }
  
  public let id: Model.ID
  private let object: String
  public let created: Date
  public let ownedBy: String
  public let permission: [Model.Permission]
  public let root: Model.ID
  public let parent: Model.ID?
  
  public init(
    id: Model.ID,
    created: Date,
    ownedBy: String,
    permission: [Model.Permission],
    root: Model.ID,
    parent: Model.ID? = nil
  ) {
    self.id = id
    self.object = "model"
    self.created = created
    self.ownedBy = ownedBy
    self.permission = permission
    self.root = root
    self.parent = parent
  }
}

extension Model {
  public struct Permission: Equatable, Codable {
    public struct ID: Identifier {
      public var value: String
      
      public init(_ value: String) {
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
