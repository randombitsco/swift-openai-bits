//
//  ModelIDTests.swift

import XCTest
@testable import OpenAIAPI

final class ModelIDTests: XCTestCase {

  func testEncodeToJSON() throws {
    let id: Model.ID = "alpha"
    let json = try jsonEncode(id)
    XCTAssertEqual("\"alpha\"", json)
  }

  func testDecodeFromJSON() throws {
    let id: Model.ID = try jsonDecode("\"alpha\"")
    XCTAssertEqual(Model.ID("alpha"), id)
  }
}
