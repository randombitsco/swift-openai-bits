@testable import OpenAIBits
import XCTest

//XCTAssertExpectOpenAICall {
//  Completions(model: "foobar", prompt: "ABC")
//} whileDoing: {
//  try await cmd.validate()
//  try await cmd.run()
//}

public func XCTAssertExpectOpenAICall<C: Call>(_ call: () -> C, whileDoing: () async throws -> Void) throws {
  var called = false
  var oldHandler: OpenAIBits.CallHandler
}
