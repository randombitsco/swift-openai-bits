import Foundation

/// Represents a `GET` HTTP request
protocol GetCall: HTTPCall {}

extension GetCall {
  /// `"GET"`
  var method: String { "GET" }
  
  /// `nil`
  var contentType: String? { nil }
  
  /// `nil`
  func getBody() throws -> Data? { nil }
}
