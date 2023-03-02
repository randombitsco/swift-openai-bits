protocol ExecutableCall: Call {
  
  /// Attempts to execute the current call with the provided ``OpenAI`` instance.
  ///
  /// - Parameter client: The ``OpenAI``, containing connection details.
  /// - Throws: An `Error` if there is a problem.
  /// - Returns: The response.
  func execute(with client: OpenAI) async throws -> Response
}
