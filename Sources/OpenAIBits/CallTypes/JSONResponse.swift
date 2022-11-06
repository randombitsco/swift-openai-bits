import Foundation

/// A ``Response`` which will decode itself from `JSON`.
protocol JSONResponse: HTTPResponse, Codable {}

extension JSONResponse {
  /// Constructs a new response based on the data and the `HTTPURLResponse`.
  /// - Parameters:
  ///   - data: The data.
  ///   - response: The HTTP response.
  init(data: Data, response: HTTPURLResponse) throws {
    guard isJSON(response: response) else {
      let contentType = response.value(forHTTPHeaderField: CONTENT_TYPE)
      throw OpenAI.Error.unexpectedResponse("Expected 'Content-Type' of '\(APPLICATION_JSON)' but got '\(contentType ?? "")'")
    }
    self = try jsonDecodeData(data)
  }
}
