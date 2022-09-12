/// Represents a `GET` HTTP request
public protocol GetCall {
  /// The response data type.
  associatedtype Response: Decodable
  
  /// The path for the call
  var path: String { get }
}

/// Represents a `POST` HTTP request.
public protocol PostCall: Encodable {  
  /// The response data type.
  associatedtype Response: Decodable

  /// The path for the call
  var path: String { get }
}
