import CustomDump
@testable import OpenAIBits
import XCTest

//XCTAssertExpectOpenAICall {
//  Completions(model: "foobar", prompt: "ABC")
//} returning: {
//  Completions.Response(...)
//} whileDoing: {
//  try await cmd.validate()
//  try await cmd.run()
//}

/// An `Error` implementation for problems while running a call.
enum TestCallError: Swift.Error {
  case expected(call: Any, received: Any)
}

class TestCallHandler<E: Call>: CallHandler {
  
  var called = false
  let expectedCall: E
  let returning: E.Response
  
  init(expectedCall: E, returning: E.Response) {
    self.expectedCall = expectedCall
    self.returning = returning
  }
  
  func execute<C>(call: C, with client: OpenAIBits.OpenAI) async throws -> C.Response where C : OpenAIBits.Call {
    guard !called else {
      throw TestCallError.expected(call: expectedCall, received: call)
    }
    guard let call = call as? E else {
      throw TestCallError.expected(call: expectedCall, received: call)
    }
    called = true
    guard call == expectedCall else {
      throw TestCallError.expected(call: expectedCall, received: call)
    }
    return returning as! C.Response
  }
}

/// A function for use during `XCTestCase` evaluation to test an `OpenAIBits` `Call`.
///
/// ## Examples
///
/// ```swift
/// func testModelsDetail() async throws {
///   let client = OpenAI(apiKey: "foobar")
///   let now = Date()
///
///   XCTAssertExpectOpenAICall {
///     Models.Detail(id: "my-model")
///   } response: {
///     Model(id: "my-model", created: now, organization: "my-org")
///   } doing: {
///     let response = try await client.call(Models.Detail(id: "my-model"))
///     XCTAssertEqual(response, Model(id: "my-model", created: now, organization: "my-org")
///   }
/// }
/// ```
///
/// Of course, this is pretty useless by itself. Where it is helpful is when working with another library that is making calls to `OpenAI` on your behalf.
///
/// - Parameters:
///   - call: Returns the expected `OpenAIBits.Call` instance.
///   - response: Returns the `OpenAIBits.Call.Response` instance.
///   - doing: A closure containing the code that will exercise the `OpenAIBits.OpenAI.run()` function.
///   - file: The originating file (defaults to the calling file).
///   - line: The originating line number (defaults to the originating line number).
/// - Throws: An error if `whileDoing` throws an error.
public func XCTAssertExpectOpenAICall<C: Call>(
  _ call: () -> C,
  response: () -> C.Response,
  doing: () async throws -> Void,
  file: StaticString = #file,
  line: UInt = #line
) async rethrows {
  let oldHandler = OpenAI.handler
  defer { OpenAI.handler = oldHandler }
  
  OpenAI.handler = TestCallHandler(expectedCall: call(), returning: response())
  
  do {
    try await doing()
  } catch let TestCallError.expected(call: expectedCall, received: receivedCall) {
    XCTAssertNoDifference(String(describing: expectedCall), String(describing: receivedCall), file: file, line: line)
  }
}
