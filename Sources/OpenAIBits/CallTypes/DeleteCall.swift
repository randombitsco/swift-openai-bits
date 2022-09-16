import Foundation

/// Represents a `DELETE` HTTP request.
public protocol DeleteCall {
  /// The response data type.
  associatedtype Response: OpenAIBits.Response
  
  var path: String { get }
}
