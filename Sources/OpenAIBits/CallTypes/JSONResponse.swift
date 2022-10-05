import Foundation

fileprivate let CONTENT_TYPE = "Content-Type"
fileprivate let APPLICATION_JSON = "application/json"

/// A ``Response`` which will decode itself from `JSON`.
protocol JSONResponse: HTTPResponse, Codable {}

extension JSONResponse {
  init(data: Data, response: HTTPURLResponse) throws {
    let contentType = response.value(forHTTPHeaderField: CONTENT_TYPE)
    guard contentType == APPLICATION_JSON else {
      throw Client.Error.unexpectedResponse("Expected 'Content-Type' of '\(APPLICATION_JSON)' but got '\(contentType ?? "")")
    }
    self = try jsonDecodeData(data)
  }
  
  /// Checks if the value in the provided ``HTTPURLResponse`` is ``JSON``.
  ///
  /// - Parameter response: The ``HTTPURLResponse``.
  static func isJSON(response: HTTPURLResponse) -> Bool {
    response.value(forHTTPHeaderField: CONTENT_TYPE)?.starts(with: APPLICATION_JSON) ?? false
  }
}
