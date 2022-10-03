/// The `Models` namespace.
///
/// - SeeAlso ``Models/List``
/// - SeeAlso ``Models/Detail``
public enum Models {
  /// A ``Call`` that will respond with a ``ListOf`` available ``Model``s.
  public struct List: GetCall {
    /// Response with a ``ListOf`` ``Model``s.
    public typealias Response = ListOf<Model>
    
    var path: String { "models" }
    
    /// Constructs the ``Models/List`` call.
    public init() {}
  }
}

extension Models { 
  /// A ``Call`` that is provided a ``Model`` `ID` and will respond with an individual ``Model``, if available.
  public struct Detail: GetCall {
    /// Responds with a ``Model``.
    public typealias Response = Model
    
    var path: String { "models/\(id.value)"}
    
    /// The ``Model`` `ID`.
    public let id: Model.ID
    
    /// Constructs a ``Models/Detail`` with the specified ``Model`` `ID`.
    ///
    /// - Parameter id: The ``Model`` `ID`.
    public init(id: Model.ID) {
      self.id = id
    }
  }
}
