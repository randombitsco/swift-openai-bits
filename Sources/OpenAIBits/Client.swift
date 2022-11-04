/// Represents the connection to the OpenAI API.
/// You must provide at least the `apiKey`, and optionally an `organisation` key and a `log` function.
public struct Client {
  /// Typealias for a logger function, which takes a `String` and outputs it.
  public typealias Logger = (String) -> Void

  /// The OpenAI API Key to use.
  let apiKey: String
  
  /// The OpenAI Organization Key to use (optional).
  let organization: String?
  
  /// A ``Logger`` function, if desired. Used for debug logging if present. Defaults to `nil`.
  let log: Logger?
  
  /// Initializes the ``Client``.
  ///
  /// - Parameters:
  ///   - apiKey: The OpenAI API Key to use.
  ///   - organization: The OpenAI Organization Key to use (optional).
  ///   - log: A ``Logger`` function, if desired. Used for debug logging if present. Defaults to `nil`.
  public init(apiKey: String, organization: String? = nil, log: Logger? = nil) {
    self.apiKey = apiKey
    self.organization = organization
    self.log = log
  }
}

extension Client {
  /// An error returned by the OpenAI API.
  public struct Error: Swift.Error, Codable, Equatable {
    /// A message describing the error.
    public let message: String
    
    /// The type of error.
    public let type: String
    
    /// The parameter that caused the error.
    public let param: String?

    /// The error code, if any.
    public let code: Int?
    
    /// Initializes a new ``Client``.
    /// - Parameters:
    ///   - type: The type of the error.
    ///   - code: The code (optional)
    ///   - param: The parameter name.
    ///   - message: The message.
    public init(type: String, code: Int? = nil, param: String? = nil, message: String) {
      self.type = type
      self.code = code
      self.param = param
      self.message = message
    }
  }
}

/// The default implementation for ``CallHandler``.
struct ExecutableCallHandler: CallHandler {
  /// Executes the call if it implements ``ExecutableCall``.
  /// - Parameters:
  ///   - call: The ``Call``.
  ///   - client: The ``Client.``
  /// - Returns: The ``Call/Response``.
  /// - Throws: An ``Client/Error`` if the ``Call`` does not implement ``ExecutableCall``, or if executing the throws an error.
  func execute<C>(call: C, with client: Client) async throws -> C.Response where C : Call {
    guard let call = call as? any ExecutableCall else {
      throw Client.Error.unsupportedCall(C.self)
    }
    let response = try await call.execute(with: client)
    guard let response = response as? C.Response else {
      throw Client.Error.unexpectedResponse(String(describing: response))
    }
    return response
  }
}

extension Client {
  /// The current ``CallHandler``. Defaults to ``HTTPCallHandler``.
  static var handler: CallHandler = ExecutableCallHandler()

  /// Execute the specified ``Call``, returning the specified ``Call/Response``.
  ///
  /// - Parameter call: The ``Call`` to execute.
  public func call<C: Call>(_ call: C) async throws -> C.Response {
    return try await Client.handler.execute(call: call, with: self)
  }
}

extension Client.Error: CustomStringConvertible, CustomDebugStringConvertible {
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
  
  public var debugDescription: String {
    description
  }
  
  /// Creates an ``Client/Error`` indicating the provided ``Call`` type is not supported.
  /// - Parameter request: The call.
  /// - Returns: The ``Client/Error``.
  static func unsupportedCall<C: Call>(_ call: C.Type) -> Client.Error {
    .init(type: "unsupported_call", message: String(describing: call))
  }
  
  /// Creates an ``Client/Error`` indicating a URL was invalid. This is usually a bug in the API.
  /// - Parameter url: The URL.
  /// - Returns: The ``Client/Error``.
  static func invalidURL(_ url: String) -> Client.Error {
    .init(type: "invalid_url", message: url)
  }
  
  /// Creates an ``Client/Error`` indicating the response was unexpected.
  /// - Parameter message: The message.
  /// - Returns: The ``Client/Error``.
  static func unexpectedResponse(_ message: String) -> Client.Error {
    .init(type: "unexpected_response", message: message)
  }
}
