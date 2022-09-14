import Foundation

/// Represents a `DELETE` HTTP request.
public protocol DeleteCall {
  /// The response data type.
  associatedtype Response: OpenAIAPI.Response
  
  var path: String { get }
}
