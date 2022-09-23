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

enum TestCallError: Swift.Error {
  case unexpectedCall(Any)
}

class TestCallHandler<E: Call>: CallHandler {
  
  var called = false
  let expectedCall: E
  let returning: E.Response
  
  init(expectedCall: E, returning: E.Response) {
    self.expectedCall = expectedCall
    self.returning = returning
  }
  
  func execute<C>(call: C, with client: OpenAIBits.Client) async throws -> C.Response where C : OpenAIBits.Call {
    guard !called else {
      throw TestCallError.unexpectedCall(call)
    }
    guard let call = call as? E else {
      throw TestCallError.unexpectedCall(call)
    }
    called = true
    guard call == expectedCall else {
      throw TestCallError.unexpectedCall(call)
    }
    return returning as! C.Response
  }
}

public func XCTAssertExpectOpenAICall<C: Call>(
  _ call: () -> C,
  returning: () -> C.Response,
  whileDoing: () async throws -> Void,
  file: StaticString = #file,
  line: UInt = #line
) async throws {
  let oldHandler = Client.handler
  defer { Client.handler = oldHandler }
  
  Client.handler = TestCallHandler(expectedCall: call(), returning: returning())
  
  do {
    try await whileDoing()
  } catch TestCallError.unexpectedCall(let call) {
    XCTFail("Unexpected Call: \(call)", file: file, line: line)
  }
}
