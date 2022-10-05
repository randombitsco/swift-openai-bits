/// A protocol for allowing a ``Client`` to handle a call.
protocol CallHandler {
  func execute<C: Call>(call: C, with client: Client) async throws -> C.Response
}
