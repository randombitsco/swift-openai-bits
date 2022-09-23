/// The `Models` namespace.
///
/// - SeeAlso ``Models/List``
/// - SeeAlso ``Models/Detail``
public enum Models {
  /// A ``GetCall`` that will respond with a ``ListOf`` available ``Model``s.
  public struct List: GetCall {
    
    public typealias Response = ListOf<Model>
    
    public var path: String { "models" }
    
    public init() {}
  }
}

extension Models { 
  /// A ``GetCall`` that is provided a ``Model.ID`` and will respond with an individual ``Model``, if available.
  public struct Detail: GetCall {
    public typealias Response = Model
    
    public var path: String { "models/\(id.value)"}
    
    public let id: Model.ID
    
    public init(for id: Model.ID) {
      self.id = id
    }
  }
}
