import Foundation

/// A ``Response`` which will decode itself from `JSON`.
protocol JSONResponse: HTTPResponse, Codable {}

extension JSONResponse {
  init(data: Data, response: HTTPURLResponse) throws {
    guard isJSON(response: response) else {
      let contentType = response.value(forHTTPHeaderField: CONTENT_TYPE)
      throw Client.Error.unexpectedResponse("Expected 'Content-Type' of '\(APPLICATION_JSON)' but got '\(contentType ?? "")'")
    }
    self = try jsonDecodeData(data)
  }
}
