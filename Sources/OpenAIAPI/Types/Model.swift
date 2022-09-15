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
  
  /// Indicates if the model is a `fine-tune`.
  public var isFineTune: Bool {
    return value.contains(":ft-")
  }
  
  public static var text_davinci_002: Self { "text-davinci-002" }
  
  public static var text_davinci_edit_001: Self { "text-davinci-edit-001" }
  
  public static var code_davinci_edit_001: Self { "code-davinci-edit-001" }
  
  public static var text_davinci_insert_002: Self { "text-davinci-insert-002" }
  
  public static var text_davinci_insert_001: Self { "text-davinci-insert-001" }
  
  public static var babbage_search_document: Self { "babbage-search-document" }
  
  public static var text_babbage_001: Self {  "text-babbage-001" }
  
  public static var code_davinci_001: Self {  "code-davinci-001" }
  
  public static var davinci_instruct_beta: Self { "davinci-instruct-beta" }
  
  public static var text_davinci_001: Self { "text-davinci-001" }
  
  public static var text_similiarity_davinci_001: Self { "text-similarity-davinci-001" }
  
  public static var davinci_similiarity: Self { "davinci-similarity" }
  
  public static var davinci_search_document: Self { "davinci-search-document" }
  
  public static var text_search_davinci_doc_001: Self { "text-search-davinci-doc-001" }
  
  public static var text_search_davinci_query_001: Self { "text-search-davinci-query-001"}
  
  public static var davinci_search_query: Self { "davinci-search-query" }
  
  public static var ada_similiarity: Self { "ada-similarity" }
  
  public static var text_similarity_ada_001: Self { "text-similarity-ada-001" }
  
  public static var cushman_2020_05_03: Self { "cushman:2020-05-03" }
  
  public static var ada_2020_05_03: Self { "ada:2020-05-03" }
  
  public static var babbage_2020_05_03: Self { "babbage:2020-05-03" }
  
  public static var curie_2020_05_03: Self { "curie:2020-05-03" }
  
  public static var davinci_2020_05_03: Self { "davinci:2020-05-03" }
  
  public static var ifDavinci200: Self { "if-davinci-v2" }
  
  public static var ifCurie200: Self { "if-curie-v2" }
  
  public static var ifDavinci300: Self { "if-davinci:3.0.0" }
  
  public static var davinciIf300: Self { "davinci-if:3.0.0" }
  
  public static var davinciInstructBeta200: Self { "davinci-instruct-beta:2.0.0" }
  
  public static var textAda001: Self { "text-ada:001" }
  
  public static var textDavinci001: Self { "text-davinci:001" }
  
  public static var textCurie001: Self { "text-curie:001" }
  
  public static var textBabbage001: Self { "text-babbage:001" }
}
