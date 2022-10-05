import Foundation

/// Represents a `POST` HTTP request.
protocol PostCall: HTTPCall {}

extension PostCall {
  /// Returns `"POST"`
  var method: String { "POST" }
}
