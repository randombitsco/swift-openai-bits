import Foundation

/// A protocol that provides required details to create an `HTTPURLRequest`.
protocol HTTPRequestable {
  /// The HTTP method for the call.
  var method: String { get }
  
  /// The relative path for the call.
  var path: String { get }
  
  /// The `Content-Type` for the body.
  var contentType: String? { get }
  
  /// The HTTP body ``Data``.
  func getBody() throws -> Data?
}

