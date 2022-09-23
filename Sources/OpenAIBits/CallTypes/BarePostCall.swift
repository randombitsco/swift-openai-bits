import Foundation

/// A convenience protocol for `POST` calls which have no body.
protocol BarePostCall: PostCall {}

extension BarePostCall {
  /// Content-Type is `nil`
  var contentType: String? { nil }
  
  /// The body is `nil`.
  func getBody() throws -> Data? { nil }
}
