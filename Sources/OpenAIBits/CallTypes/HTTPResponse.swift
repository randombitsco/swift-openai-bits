import Foundation

/// Indicates a response is provided via HTTP.
protocol HTTPResponse: Equatable {
  
  /// Initialises the ``HTTPResponse``.
  /// - Parameters:
  ///   - data: The data for the response.
  ///   - response: The `Foundation.HTTPURLResponse` value.
  init(data: Data, response: HTTPURLResponse) throws
}
