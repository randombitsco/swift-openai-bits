import XCTest
@testable import OpenAIBits

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
  
  func testEncodeTokenArrayToJSON() throws {
    let prompt: Prompt = .tokenArray([1, 2, 100])
    let json = try jsonEncode(prompt)
    XCTAssertEqual("[1,2,100]", json)
  }
  
  func testEncodeTokenArraysToJSON() throws {
    let prompt: Prompt = .tokenArrays([[1, 2], [100, 200]])
    let json = try jsonEncode(prompt)
    XCTAssertEqual("[[1,2],[100,200]]", json)
  }
  
  func testDecodeStringFromJSON() throws {
    let result: Prompt = try jsonDecode("\"gamma\"")
    XCTAssertEqual(.string("gamma"), result)
  }
  
  func testDecodeStringsFromJSON() throws {
    let result: Prompt = try jsonDecode("[\"gamma\",\"delta\"]")
    XCTAssertEqual(.strings(["gamma", "delta"]), result)
  }
  
  func testDecodeTokenArraysFromJSON() throws {
    let result: Prompt = try jsonDecode("[1,2,100]")
    XCTAssertEqual(.tokenArray([1,2,100]), result)
  }

  func testDecodeTokensArraysFromJSON() throws {
    let result: Prompt = try jsonDecode("[[1,2],[100,200]]")
    XCTAssertEqual(.tokenArrays([[1,2],[100,200]]), result)
  }
}
