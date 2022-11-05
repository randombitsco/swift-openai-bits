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
      #"{"b64_json":"QUJD"}"#,
      try jsonEncode(value, options: [.withoutEscapingSlashes]))
  }

  func testImageDataBase64FromJSON() throws {
    let data = "ABC".data(using: .utf8)!
    let value: Image.Data = try jsonDecode(#"{"b64_json":"QUJD"}"#)
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
  
  func testImagesRequestFormatToJSON() throws {
    let value = Images.ResponseFormat.base64
    XCTAssertEqual(#""b64_json""#, try jsonEncode(value))
  }
  
  func testImagesGenerationsToJSON() throws {
    let value = Images.Generations(
      prompt: "foobar",
      n: 2,
      size: .of256x256,
      responseFormat: .base64,
      user: "jblogs"
    )
    
    XCTAssertNoDifference(
      #"{"n":2,"prompt":"foobar","response_format":"b64_json","size":"256x256","user":"jblogs"}"#,
      try jsonEncode(value, options: [.withoutEscapingSlashes,.sortedKeys])
    )
  }

}
