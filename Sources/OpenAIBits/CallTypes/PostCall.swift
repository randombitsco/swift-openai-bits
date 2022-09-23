import Foundation

/// Represents a `POST` HTTP request.
protocol PostCall: Call {}

extension PostCall {
  /// Returns `"POST"`
  var method: String { "POST" }
}
