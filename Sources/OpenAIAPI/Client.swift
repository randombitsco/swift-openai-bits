import Foundation
import MultipartForm

fileprivate let BASE_URL = "https://api.openai.com/v1"

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

private func logHeaders(_ headers: [AnyHashable:Any]?, from label: String, to log: Client.Logger?) {
  guard let log = log, let headers = headers else { return }
  
  log("\(label) Headers:")
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
  private struct ErrorResponse: JSONResponse {
    let error: Error
  }
  
  private func executeRequest<T: Response>(_ request: URLRequest, returning outputType: T.Type = T.self) async throws -> T {
    do {
      log?("Request: \(request.httpMethod ?? "GET") \(request)")
      logHeaders(request.allHTTPHeaderFields, from: "Request", to: self.log)
      if let httpBody = request.httpBody {
        log?("Request Data:\n\(String(decoding: httpBody, as: UTF8.self))")
      }
      
      let (result, response) = try await URLSession.shared.data(for: request)

      guard let httpResponse = response as? HTTPURLResponse else {
        throw Client.Error.unexpectedResponse("Expected an HTTPURLResponse")
      }

      log?("\nResponse Status: \(httpResponse.statusCode)")
      logHeaders(httpResponse.allHeaderFields, from: "Response", to: self.log)
      
      guard httpResponse.statusCode == 200 else {
        if ErrorResponse.isJSON(response: httpResponse) {
          do {
            throw try ErrorResponse(data: result, response: httpResponse).error
          } catch {
            throw error
          }
        } else {
          throw Error.unexpectedResponse("\(httpResponse.statusCode): \(String(decoding: result, as: UTF8.self))")
        }
      }
      
      log?("Response Data:\n\(String(decoding: result, as: UTF8.self))")
      return try T(data: result, response: httpResponse)
    } catch {
      log?("Error: \(error)")
      throw error
    }
  }
}

extension Client {

  private func buildRequest(to path: String, method: String) throws -> URLRequest {
    let urlStr = "\(BASE_URL)/\(path)"

    guard let url = URL(string: urlStr) else {
      throw Client.Error.invalidURL(urlStr)
    }

    var request = URLRequest(url: url)
    request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
    if let organization = organization {
      request.setValue(organization, forHTTPHeaderField: "OpenAI-Organization")
    }
    
    request.httpMethod = method

    return request
  }
  
  private func buildRequest<C: GetCall>(for request: C) throws -> URLRequest {
    return try buildRequest(to: request.path, method: "GET")
  }
  
  /// Builds a `POST` request based on the ``PostCall`` provided.
  ///
  /// - Parameter call: The ``PostCall`` instance.
  /// - Returns the new ``URLRequest``.
  private func buildRequest<C: PostCall>(for call: C) throws -> URLRequest {
    var request = try buildRequest(to: call.path, method: "POST")
    request.setValue(call.contentType, forHTTPHeaderField: "Content-Type")
    request.httpBody = try call.getBody()
    return request
  }
  
  private func buildRequest<C: DeleteCall>(for call: C) throws -> URLRequest {
    return try buildRequest(to: call.path, method: "DELETE")
  }
  
  public func call<C: GetCall>(_ request: C) async throws -> C.Response {
    return try await executeRequest(buildRequest(for: request))
  }

  public func call<C: PostCall>(_ request: C) async throws -> C.Response {
    return try await executeRequest(buildRequest(for: request))
  }
  
  public func call<C: DeleteCall>(_ request: C) async throws -> C.Response {
    return try await executeRequest(buildRequest(for: request))
  }
}

extension Client.Error: CustomStringConvertible {
  public var description: String {
    var result = message
    if let param = param {
      result.append("\nParameter: \(param)")
    }
    if let code = code {
      result.append("\nCode: \(code)")
    }
    return result
  }
  
  static func invalidURL(_ url: String) -> Client.Error {
    .init(type: "invalid_url", message: url)
  }
  
  static func unexpectedResponse(_ message: String) -> Client.Error {
    .init(type: "unexpected_response", message: message)
  }
}
