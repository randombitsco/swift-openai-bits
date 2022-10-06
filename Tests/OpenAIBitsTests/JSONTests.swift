import Foundation
import CustomDump
@testable import OpenAIBits
import XCTest


final class JSONTests: XCTestCase {
  
  func testTokenStringDictionaryToJSON() throws {
    @CodableDictionary var dict: [Token: Int]? = [12: 34, 56: 78]
    
    let encoded = try jsonEncode(_dict, options: [.sortedKeys])
    
    XCTAssertNoDifference(encoded, """
    {"12":34,"56":78}
    """)
  }
  
  func testTokenStringDictionaryFromJSON() throws {
    let json = """
    {"12":34,"56":78}
    """
    
    @CodableDictionary var decoded: [Token: Int]?
    _decoded = try jsonDecode(json)
    
    XCTAssertNoDifference(decoded, [
      12: 34, 56: 78
    ])
  }
  
  func testIsJSON() {
    XCTAssertTrue(isJSON(contentType: "application/json"), "application/json")
    XCTAssertTrue(isJSON(contentType: "application/json"), "application/json; charset=utf-8")
    XCTAssertFalse(isJSON(contentType: "foo/bar"), "foo/bar")
  }
}
