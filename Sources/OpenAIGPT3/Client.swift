import Foundation

fileprivate let BASE_URL = "https://api.openai.com/v1"
fileprivate let APPLICATION_JSON = "application/json"

/// Represents the connection to the OpenAI API.
/// You must provide at least the `apiKey`, and optionally an `organisation` key and a `log` function.
public struct Client {
  /// Typealias for a logger function, which takes a ``String`` and outputs it.
  public typealias Logger = (String) -> Void
  
  let apiKey: String
  let organization: String?
  let log: Logger?
  
  public init(apiKey: String, organization: String? = nil, log: Logger? = nil) {
    self.apiKey = apiKey
    self.organization = organization
    self.log = log
  }
}

extension Client {
  public enum Error: Swift.Error {
    case invalidURL(String)
    case unexpectedResponse(String)
  }
}

extension Client {
  private enum Endpoint: CustomStringConvertible {
    case models
    case model(Model.ID)
    case completions
    case edits
    
    var path: String {
      switch(self) {
      case .models:
        return "models"
      case .model(let id):
        return "models/\(id)"
      case .completions:
        return "completions"
      case .edits:
        return "edits"
      }
    }
    
    var description: String {
      self.path
    }
  }
  
  /// Builds a ``URLRequest`` based on the ``Endpoint`` and `body` value.
  ///
  /// - Parameter endpoint: The ``Endpoint`` being requested.
  /// - Parameter body: The ``Encodable`` value to send as the request body.
  private func buildRequest(to endpoint: Endpoint, body: Encodable? = nil) throws -> URLRequest {
    let urlStr = "\(BASE_URL)/\(endpoint)"
    
    guard let url = URL(string: urlStr) else {
      throw Client.Error.invalidURL(urlStr)
    }
    
    var request = URLRequest(url: url)
    request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
    if let organization = organization {
      request.setValue(organization, forHTTPHeaderField: "OpenAI-Organization")
    }
    if let body = body {
      request.setValue(APPLICATION_JSON, forHTTPHeaderField: "Content-Type")
      request.httpBody = try JSONEncoder().encode(body)
    }
    
    return request
  }
  
  private func executeRequest<T: Decodable>(to endpoint: Endpoint, body: Encodable? = nil, returning outputType: T.Type = T.self) async throws -> T {
    do {
      let request = try buildRequest(to: endpoint, body: body)
      self.log?("Request: \(request)")
      let (result, response) = try await URLSession.shared.data(for: request)
      
      guard let httpResponse = response as? HTTPURLResponse else {
        throw Client.Error.unexpectedResponse("Expected an HTTPURLResponse")
      }
      
      switch httpResponse.statusCode {
      case 200:
        break
      default:
        throw Error.unexpectedResponse("\(httpResponse.statusCode): \(result)")
      }
      
      if httpResponse.mimeType == APPLICATION_JSON {
        let resultString = String(decoding: result, as: UTF8.self)
        self.log?("Response Data: \(resultString)")
        return try jsonDecode(resultString, as: outputType)
      } else {
        throw Client.Error.unexpectedResponse("Unexpected mime-type: \(httpResponse.mimeType ?? "<undefined>")")
      }
    } catch {
      self.log?("Error: \(error)")
      throw error
    }
  }
}

extension Client {
  /// Requests the list of models available.
  ///
  /// - Returns the list of available ``Model``s.
  public func models() async throws -> [Model] {
    return try await executeRequest(to: .models)
  }
  
  /// Requests the details for the specified ``Model/ID``.
  ///
  /// - Parameter id: The ``Model/ID``
  /// - Returns the model details.
  public func model(for id: Model.ID) async throws -> Model {
    return try await executeRequest(to: .model(id))
  }
  
  /// Requests completions for the given request.
  ///
  /// - Parameter request: The ``Completions/Request``.
  /// - Returns The ``Completions/Response``
  public func completions(for request: Completions.Request) async throws -> Completions.Response {
    return try await executeRequest(to: .completions, body: request)
  }
  
  /// Requests edits for the given request.
  ///
  /// - Parameter request: The ``Edits/Request``
  /// - Returns the ``Edits/Response``
  public func edits(for request: Edits.Request) async throws -> Edits.Request {
    return try await executeRequest(to: .edits, body: request)
  }
}
