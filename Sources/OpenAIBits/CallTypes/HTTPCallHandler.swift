import Foundation

fileprivate let BASE_URL = "https://api.openai.com/v1"

private func logHeaders(_ headers: [AnyHashable:Any]?, from label: String, to log: Client.Logger?) {
  guard let log = log, let headers = headers else { return }
  
  log("\(label) Headers:")
  log("-------------------------------------------")
  for (k,v) in headers {
    log("\(k): \(v)")
  }
  log("-------------------------------------------")
}

struct HTTPCallHandler: CallHandler {
  /// Used to parse an error response from the API.
  struct ErrorResponse: JSONResponse {
    let error: Client.Error
  }

  func execute<C: Call>(call: C, with client: Client) async throws -> C.Response {
    guard let requestable = call as? any HTTPRequestable else {
      throw Client.Error.unsupportedCall(C.self)
    }

    let urlStr = "\(BASE_URL)/\(requestable.path)"

    guard let url = URL(string: urlStr) else {
      throw Client.Error.invalidURL(urlStr)
    }

    var request = URLRequest(url: url)
    request.setValue("Bearer \(client.apiKey)", forHTTPHeaderField: "Authorization")
    if let organization = client.organization {
      request.setValue(organization, forHTTPHeaderField: "OpenAI-Organization")
    }
    
    request.httpMethod = requestable.method

    if let contentType = requestable.contentType {
      request.setValue(contentType, forHTTPHeaderField: "Content-Type")
    }
    if let body = try requestable.getBody() {
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
      
      client.log?("Response Data:\n\(String(decoding: result, as: UTF8.self))")
      
      guard httpResponse.statusCode == 200 else {
        if isJSON(response: httpResponse) {
          do {
            throw try ErrorResponse(data: result, response: httpResponse).error
          } catch {
            throw error
          }
        } else {
          throw Client.Error.unexpectedResponse("\(httpResponse.statusCode): \(String(decoding: result, as: UTF8.self))")
        }
      }
      
      guard let responseType = C.Response.self as? any HTTPResponse.Type else {
        throw Client.Error.unexpectedResponse(String(decoding: result, as: UTF8.self))
      }
      return try createResponse(as: responseType, data: result, response: httpResponse) as! C.Response
    } catch {
      client.log?("Error: \(error)\n")
      throw error
    }

  }
  
  func createResponse<R: HTTPResponse>(as: R.Type = R.self, data: Data, response: HTTPURLResponse) throws -> R {
    try R(data: data, response: response)
  }
}

