protocol ExecutableCall: Call {
  
  /// Attempts to execute the current call with the provided ``Client``.
  ///
  /// - Parameter client: The ``Client``, containing connection details.
  /// - Throws: An `Error` if there is a problem.
  /// - Returns: The response.
  func execute(with client: OpenAI) async throws -> Response
}
