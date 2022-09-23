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
  public struct Error: Swift.Error, Decodable, Equatable {
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

protocol CallHandler {
  func execute<C: Call>(call: C, with client: Client) async throws -> C.Response
}

struct HTTPCallHandler: CallHandler {
  /// Used to parse an error response from the API.
  struct ErrorResponse: JSONResponse {
    let error: Client.Error
  }

  func execute<C: Call>(call: C, with client: Client) async throws -> C.Response {
    guard let call = call as? any HTTPCall else {
      throw Client.Error.unsupportedCall(C.self)
    }
    return try await execute(call: call, with: client) as! C.Response
  }
  
  func execute<C: HTTPCall>(call: C, with client: Client) async throws -> C.Response {
    let urlStr = "\(BASE_URL)/\(call.path)"

    guard let url = URL(string: urlStr) else {
      throw Client.Error.invalidURL(urlStr)
    }

    var request = URLRequest(url: url)
    request.setValue("Bearer \(client.apiKey)", forHTTPHeaderField: "Authorization")
    if let organization = client.organization {
      request.setValue(organization, forHTTPHeaderField: "OpenAI-Organization")
    }
    
    request.httpMethod = call.method

    if let contentType = call.contentType {
      request.setValue(contentType, forHTTPHeaderField: "Content-Type")
    }
    if let body = try call.getBody() {
      request.httpBody = body
    }
    
    do {
      client.log?("Request: \(request.httpMethod ?? "GET") \(request)")
      logHeaders(request.allHTTPHeaderFields, from: "Request", to: client.log)
      if let httpBody = request.httpBody {
        client.log?("Request Data:\n\(String(decoding: httpBody, as: UTF8.self))")
      }
      
      let (result, response) = try await URLSession.shared.data(for: request)

      guard let httpResponse = response as? HTTPURLResponse else {
        throw Client.Error.unexpectedResponse("Expected an HTTPURLResponse")
      }

      client.log?("\nResponse Status: \(httpResponse.statusCode)")
      logHeaders(httpResponse.allHeaderFields, from: "Response", to: client.log)
      
      guard httpResponse.statusCode == 200 else {
        if ErrorResponse.isJSON(response: httpResponse) {
          do {
            throw try ErrorResponse(data: result, response: httpResponse).error
          } catch {
            throw error
          }
        } else {
          throw Client.Error.unexpectedResponse("\(httpResponse.statusCode): \(String(decoding: result, as: UTF8.self))")
        }
      }
      
      client.log?("Response Data:\n\(String(decoding: result, as: UTF8.self))")
      return try C.Response(data: result, response: httpResponse)
    } catch {
      client.log?("Error: \(error)")
      throw error
    }

  }
}

extension Client {
  /// The current ``CallHandler``. Defaults to ``HTTPCallHandler``.
  static var handler: CallHandler = HTTPCallHandler()
}

extension Client {
  /// Execute the specified ``Call``, returning the specified ``Call/Response``.
  ///
  /// - Parameter call: The ``Call`` to execute.
  public func call<C: Call>(_ call: C) async throws -> C.Response {
    return try await Client.handler.execute(call: call, with: self)
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
  
  static func unsupportedCall<C: Call>(_ request: C.Type) -> Client.Error {
    .init(type: "unsupported_call", message: String(describing: request))
  }
  
  static func invalidURL(_ url: String) -> Client.Error {
    .init(type: "invalid_url", message: url)
  }
  
  static func unexpectedResponse(_ message: String) -> Client.Error {
    .init(type: "unexpected_response", message: message)
  }
}
