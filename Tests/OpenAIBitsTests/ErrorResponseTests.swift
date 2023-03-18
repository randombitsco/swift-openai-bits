import XCTest
@testable import OpenAIBits

final class ErrorResponseTests: XCTestCase {

  func testEncodeToJSON() throws {
    let error = OpenAI.Error(
      type: "invalid_request_error",
      code: "model_not_found",
      param: "model",
      message: "The model 'gpt-4-turbo' does not exist"
    )
    let json = try jsonEncode(error, options: [.sortedKeys])
    XCTAssertEqual("""
    {"code":"model_not_found","message":"The model 'gpt-4-turbo' does not exist","param":"model","type":"invalid_request_error"}
    """, json)
  }

  func testDecodeFromJSON() throws {
    let error: OpenAI.Error = try jsonDecode("""
    {
      "message": "The model 'gpt-4-turbo' does not exist",
      "type": "invalid_request_error",
      "param": "model",
      "code": "model_not_found"
    }
    """)
    XCTAssertEqual(
      OpenAI.Error(
        type: "invalid_request_error",
        code: "model_not_found",
        param: "model",
        message: "The model 'gpt-4-turbo' does not exist"
      ),
      error
    )
  }
}
