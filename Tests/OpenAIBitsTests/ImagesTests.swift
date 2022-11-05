import XCTest
import CustomDump
@testable import OpenAIBits

final class ImagesTests: XCTestCase {

    func testImageDataURLToJSON() throws {
      let value = Image.Data.url(URL(string: "http://foo.bar")!)
      XCTAssertNoDifference(
        #"{"url":"http://foo.bar"}"#,
        try jsonEncode(value, options: [.withoutEscapingSlashes]))
    }
  
  func testImageDataURLFromJSON() throws {
    let value: Image.Data = try jsonDecode(#"{"url":"http://foo.bar"}"#)
    XCTAssertNoDifference(
      Image.Data.url(URL(string: "http://foo.bar")!),
      value
    )
  }

  func testImageDataBase64ToJSON() throws {
    let data = "ABC".data(using: .utf8)!
    let value = Image.Data.base64(data)
    XCTAssertNoDifference(
      #"{"base64":"QUJD"}"#,
      try jsonEncode(value, options: [.withoutEscapingSlashes]))
  }

  func testImageDataBase64FromJSON() throws {
    let data = "ABC".data(using: .utf8)!
    let value: Image.Data = try jsonDecode(#"{"base64":"QUJD"}"#)
    XCTAssertNoDifference(
      Image.Data.base64(data),
      value
    )
  }

  func testImageToJSON() throws {
    let now = Date(timeIntervalSince1970: 1589478378)
    let value = Image(
      created: now,
      data: [.url(URL(string: "http://foo.bar")!)]
    )
    
    XCTAssertNoDifference("""
      {"created":1589478378,"data":[{"url":"http://foo.bar"}]}
      """,
      try jsonEncode(value, options: [.withoutEscapingSlashes])
    )
  }

}
