/// A protocol that represents a value with an ``Identifier``
public protocol Identified {
  /// The type for the ``Identified/id-swift.property``.
  associatedtype ID: Identifier
  
  /// The unique `ID` for the value.
  var id: ID { get }
}
