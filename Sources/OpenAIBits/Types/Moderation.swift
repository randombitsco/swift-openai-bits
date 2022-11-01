import Foundation

// MARK: Moderation

/// The response from a ``Moderations/Create`` call.
public struct Moderation: Identifiable, JSONResponse {
  /// The unique identifier for the moderation response.
  public struct ID: Identifier {
    public var value: String
    
    public init(_ value: String) {
      self.value = value
    }
  }
  
  /// The ``Moderation/ID-swift.struct``.
  public let id: ID
  
  /// The actual moderation ``Model/ID-swift.struct`` used to perform the moderation.
  public let model: Model.ID
  
  /// The list of ``Moderation/Result``s.
  public let results: [Result]
  
  /// Creates a ``Moderation`` with a specified `id`, `model` and `result`.
  ///
  /// - Parameters:
  ///   - id: The ``Moderation/ID-swift.struct``.
  ///   - model: The actual ``Model/ID-swift.struct`` used to perform the moderation.
  ///   - results: The list of ``Moderation/Result``s.
  public init(id: ID, model: Model.ID, results: [Result]) {
    self.id = id
    self.model = model
    self.results = results
  }
}

// MARK: Moderation.Category

extension Moderation {
  /// ``Moderation`` categories.
  public enum Category: String, Hashable, Codable, CaseIterable, CustomStringConvertible {
    case hate
    case hateThreatening = "hate/threatening"
    case selfHarm = "self-harm"
    case sexual
    case sexualMinors = "sexual/minors"
    case violence
    case violenceGraphic = "violence/graphic"
    
    public var description: String { rawValue }
  }
}

// MARK: Moderation.Result

extension Moderation {
  /// A single ``Moderation`` result.
  public struct Result: Codable, Equatable {
    /// The set of ``Moderation/Category`` types in the ``Moderation/Result``.
    @CodableDictionary public var categories: [Category: Bool]?
    
    /// The set of ``Moderation/Category`` scores in the ``Moderation/Result``.
    @CodableDictionary public var categoryScores: [Category: Decimal]?
    
    /// Indicates if the result was flagged in any category.
    public let flagged: Bool
    
    /// Constructs a ``Moderation/Result``.
    ///
    /// - Parameters:
    ///   - categories: The set of ``Moderation/Category`` results.
    ///   - categoryScores: The set of ``Moderation/Category`` scores.
    ///   - flagged: Is `true` if any category was flagged.
    public init(categories: [Category : Bool], categoryScores: [Category : Decimal], flagged: Bool) {
      self.categories = categories
      self.categoryScores = categoryScores
      self.flagged = flagged
    }
  }
}
