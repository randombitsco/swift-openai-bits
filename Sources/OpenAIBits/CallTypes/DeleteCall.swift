import Foundation

/// Represents a `DELETE` HTTP request.
protocol DeleteCall: HTTPCall {}

extension DeleteCall {
  /// `"DELETE"`
  var method: String { "DELETE" }
  
  /// `nil`
  var contentType: String? { nil }
  
  /// `nil`
  func getBody() throws -> Data? { nil }
}
