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

/// Represents a `POST` HTTP request that submits as a Multi-Part Form.
public protocol MultiPartCall: Encodable {  
  /// The response data type.
  associatedtype Response: Decodable

  /// The path for the call
  var path: String { get }

  /// The data to post.
  var data: Data { get }
}
