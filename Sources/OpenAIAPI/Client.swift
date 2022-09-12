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

private func logHeaders(_ headers: [AnyHashable:Any], to log: Client.Logger?) {
  guard let log = log else { return }
  
  log("Headers:")
  log("-------------------------------------------")
  for (k,v) in headers {
    log("\(k): \(v)")
  }
  log("-------------------------------------------")
}

extension Client {
  /// An error returned by the OpenAI API.
  public struct Error: Swift.Error, Decodable {
    /// A message describing the error.
    public let message: String
    
    /// The type of error.
    public let type: String
    
    /// The parameter that caused the error.
    public let param: String?

    /// The error code, if any.
    public let code: Int?

    public init(type: String, code: Int? = nil, param: String? = nil, message: String) {
      self.type = type
      self.code = code
      self.param = param
      self.message = message
    }
  }
}

extension Client {
  private enum Endpoint: CustomStringConvertible {
    case models
    case model(Model.ID)
    case completions
    case edits
    case embeddings

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
      case .embeddings:
        return "embeddings"
      }
    }

    var description: String {
      self.path
    }
  }

  private func buildRequest(to endpoint: Endpoint) throws -> URLRequest {
    let urlStr = "\(BASE_URL)/\(endpoint)"

    guard let url = URL(string: urlStr) else {
      throw Client.Error.invalidURL(urlStr)
    }

    var request = URLRequest(url: url)
    request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
    if let organization = organization {
      request.setValue(organization, forHTTPHeaderField: "OpenAI-Organization")
    }

    return request
  }

  /// Builds a ``URLRequest`` based on the ``Endpoint`` and `body` value.
  ///
  /// - Parameter endpoint: The ``Endpoint`` being requested.
  /// - Parameter body: The ``Encodable`` value to send as the request body.
  private func buildRequest<B: Encodable>(to endpoint: Endpoint, body: B) throws -> URLRequest {
    var request = try buildRequest(to: endpoint)
    request.setValue(APPLICATION_JSON, forHTTPHeaderField: "Content-Type")
    request.httpBody = try jsonEncodeData(body)
    request.httpMethod = "POST"

    return request
  }

  private func executeRequest<T: Decodable>(_ request: URLRequest, returning outputType: T.Type = T.self) async throws -> T {
    do {
      self.log?("Request: \(request.httpMethod ?? "GET") \(request)")
      let (result, response) = try await URLSession.shared.data(for: request)

      guard let httpResponse = response as? HTTPURLResponse else {
        throw Client.Error.unexpectedResponse("Expected an HTTPURLResponse")
      }

      switch httpResponse.statusCode {
      case 200:
        break
      default:
        logHeaders(httpResponse.allHeaderFields, to: self.log)
        
        if let contentType = httpResponse.allHeaderFields["Content-Type"] as? String,
           contentType == "application/json" {
          self.log?("Error result: \(String(decoding: result, as: UTF8.self))")
          let err: Response = try jsonDecodeData(result)
          throw err.error
        } else {
          throw Error.unexpectedResponse("\(httpResponse.statusCode): \(String(decoding: result, as: UTF8.self))")
        }
      }

      if httpResponse.mimeType == APPLICATION_JSON {
        let resultString = String(decoding: result, as: UTF8.self)
        self.log?("Response Data: \(resultString)")
        return try jsonDecodeData(result, as: outputType)
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
//  public func models() async throws -> [Model] {
//    return try await executeRequest(buildRequest(to: .models))
//  }

  /// Requests the details for the specified ``Model/ID``.
  ///
  /// - Parameter id: The ``Model/ID``
  /// - Returns the model details.
//  public func model(for id: Model.ID) async throws -> Model {
//    return try await executeRequest(buildRequest(to: .model(id)))
//  }

  /// Requests completions for the given request.
  ///
  /// - Parameter request: The ``Completions/Request``.
  /// - Returns The ``Completions/Response``
//  public func completions(for request: Completions) async throws -> Completions.Response {
//    return try await executeRequest(buildRequest(to: .completions, body: request))
//  }

  /// Requests edits for the given request.
  ///
  /// - Parameter request: The ``Edits/Request``
  /// - Returns the ``Edits/Response``
  public func edits(for request: Edits) async throws -> Edits.Response {
    return try await executeRequest(buildRequest(to: .edits, body: request))
  }

  public func embeddings(for request: Embeddings.Request) async throws -> Embeddings.Response {
    return try await executeRequest(buildRequest(to: .embeddings))
  }
}

extension Client {

  private func buildRequest(to path: String) throws -> URLRequest {
    let urlStr = "\(BASE_URL)/\(path)"

    guard let url = URL(string: urlStr) else {
      throw Client.Error.invalidURL(urlStr)
    }

    var request = URLRequest(url: url)
    request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
    if let organization = organization {
      request.setValue(organization, forHTTPHeaderField: "OpenAI-Organization")
    }

    return request
  }

  /// Builds a ``URLRequest`` based on the ``Endpoint`` and `body` value.
  ///
  /// - Parameter endpoint: The ``Endpoint`` being requested.
  /// - Parameter body: The ``Encodable`` value to send as the request body.
  private func buildRequest<B: Encodable>(to path: String, with body: B) throws -> URLRequest {
    var request = try buildRequest(to: path)
    request.setValue(APPLICATION_JSON, forHTTPHeaderField: "Content-Type")
    request.httpBody = try jsonEncodeData(body)
    request.httpMethod = "POST"

    return request
  }

  public func call<C: GetCall>(_ request: C) async throws -> C.Response {
    return try await executeRequest(buildRequest(to: request.path))
  }

  public func call<C: PostCall>(_ request: C) async throws -> C.Response {
    return try await executeRequest(buildRequest(to: request.path, with: request))
  }
}

extension Client.Error {
  static func invalidURL(_ url: String) -> Client.Error {
    .init(type: "invalid_url", message: url)
  }
  
  static func unexpectedResponse(_ message: String) -> Client.Error {
    .init(type: "unexpected_response", message: message)
  }
}

fileprivate struct Response: Decodable {
  let error: Client.Error
}
