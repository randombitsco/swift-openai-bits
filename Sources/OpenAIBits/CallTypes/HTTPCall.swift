import Foundation

/// A type of ``Call`` that will be triggered via a HTTP request.
protocol HTTPCall: Call, HTTPRequestable, ExecutableCall where Response: HTTPResponse {}

extension HTTPCall {
  func execute(with client: OpenAI) async throws -> Response {
    let urlStr = "\(BASE_URL)/\(path)"

    guard let url = URL(string: urlStr) else {
      throw OpenAI.Error.invalidURL(urlStr)
    }

    var request = URLRequest(url: url)
    request.setValue("Bearer \(client.apiKey)", forHTTPHeaderField: "Authorization")
    if let organization = client.organization {
      request.setValue(organization, forHTTPHeaderField: "OpenAI-Organization")
    }
    
    request.httpMethod = method

    if let contentType = contentType {
      request.setValue(contentType, forHTTPHeaderField: "Content-Type")
    }
    if let body = try getBody() {
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
        throw OpenAI.Error.unexpectedResponse("Expected an HTTPURLResponse")
      }

      client.log?("Response Status: \(httpResponse.statusCode)")
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
          throw OpenAI.Error.unexpectedResponse("\(httpResponse.statusCode): \(String(decoding: result, as: UTF8.self))")
        }
      }
      return try Response(data: result, response: httpResponse)
    } catch {
      client.log?("Error: \(error)\n")
      throw error
    }
  }
}

// MARK: Private constants

fileprivate let BASE_URL = "https://api.openai.com/v1"

/// Used to parse an error response from the API.
private struct ErrorResponse: JSONResponse {
  let error: OpenAI.Error
}

private func logHeaders(_ headers: [AnyHashable:Any]?, from label: String, to log: OpenAI.Logger?) {
  guard let log = log, let headers = headers else { return }
  
  log("\(label) Headers:")
  log("-------------------------------------------")
  for (k,v) in headers {
    log("\(k): \(v)")
  }
  log("-------------------------------------------")
}

