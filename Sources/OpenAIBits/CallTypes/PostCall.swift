import Foundation

/// Represents a `POST` HTTP request.
public protocol PostCall {
  /// The response data type.
  associatedtype Response: OpenAIBits.Response

  /// The path for the call
  var path: String { get }
  
  /// The Content-Type for the body.
  var contentType: String? { get }
  
  /// The HTTP body `Data`.
  func getBody() throws -> Data?
}
