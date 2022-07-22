/// Represents a `GET` HTTP request
public protocol GetCall {
  /// The response data type.
  associatedtype Response: Decodable
  
  /// The path for the call
  var path: String { get }
}

public protocol PostCall: Encodable {  
  /// The response data type.
  associatedtype Response: Decodable

  /// The path for the call
  var path: String { get }
}
