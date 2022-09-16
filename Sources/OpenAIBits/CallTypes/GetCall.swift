import Foundation

/// Represents a `GET` HTTP request
public protocol GetCall {
  /// The response data type.
  associatedtype Response: OpenAIBits.Response
  
  /// The path for the call
  var path: String { get }
}
