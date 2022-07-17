import XCTest
@testable import OpenAIGPT3

final class PromptTests: XCTestCase {

    func testEncodeStringToJSON() throws {
      let prompt: Prompt = .string("alpha")
      let json = try jsonEncode(prompt)
      XCTAssertEqual("\"alpha\"", json)
    }
  
  func testEncodeStringsToJSON() throws {
    let prompt: Prompt = .strings(["alpha","beta"])
    let json = try jsonEncode(prompt)
    XCTAssertEqual("[\"alpha\",\"beta\"]", json)
  }
  
  func testDecodeStringFromJSON() throws {
    let result: Prompt = try jsonDecode("\"gamma\"")
    XCTAssertEqual(.string("gamma"), result)
  }
  
  func testDecodeStringsFromJSON() throws {
    let result: Prompt = try jsonDecode("[\"gamma\",\"delta\"]")
    XCTAssertEqual(.strings(["gamma", "delta"]), result)
  }

}
