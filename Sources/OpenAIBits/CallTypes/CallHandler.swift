/// A protocol for allowing a ``Client`` to handle a call.
///
/// ## See Also
///
/// - ``Client``
protocol CallHandler {
  
  /// Executes the provided call, via the `client`.
  /// - Parameters:
  ///   - call: The ``Call``.
  ///   - client: The ``Client``.
  /// - Returns: The response, if successful.
  func execute<C: Call>(call: C, with client: Client) async throws -> C.Response
}
