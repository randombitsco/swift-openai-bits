/// A protocol for allowing a ``OpenAI`` to handle a call.
///
/// ## See Also
///
/// - ``OpenAI``
protocol CallHandler {
  
  /// Executes the provided call, via the `client`.
  /// - Parameters:
  ///   - call: The ``Call``.
  ///   - client: The ``OpenAI`` client.
  /// - Returns: The response, if successful.
  func execute<C: Call>(call: C, with client: OpenAI) async throws -> C.Response
}
