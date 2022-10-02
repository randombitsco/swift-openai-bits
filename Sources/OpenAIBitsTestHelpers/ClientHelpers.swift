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
  
  func execute<C>(call: C, with client: OpenAIBits.Client) async throws -> C.Response where C : OpenAIBits.Call {
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
  } catch let TestCallError.expected(call: expectedCall, received: receivedCall) {
    XCTAssertNoDifference(String(describing: expectedCall), String(describing: receivedCall), file: file, line: line)
  }
}
