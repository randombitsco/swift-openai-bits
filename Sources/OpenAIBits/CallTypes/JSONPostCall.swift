import Foundation

/// A ``PostCall`` that encodes itself as JSON when posting.
protocol JSONPostCall: PostCall, Encodable {}

extension JSONPostCall {
  /// `"application/json"`
  var contentType: String? { "application/json" }
  
  /// Returns the body as `Data`, if provided.
  /// - Returns: The `Data`.
  func getBody() throws -> Data? {
    try jsonEncodeData(self)
  }
}
