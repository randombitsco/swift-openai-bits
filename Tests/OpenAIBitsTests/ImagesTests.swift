import XCTest
import CustomDump
@testable import OpenAIBits

final class ImagesTests: XCTestCase {

  func testImageDataURLToJSON() throws {
    let value = Generations.Image.url(URL(string: "http://foo.bar")!)
    XCTAssertNoDifference(
      #"{"url":"http://foo.bar"}"#,
      try jsonEncode(value, options: [.withoutEscapingSlashes]))
  }

  func testImageDataURLFromJSON() throws {
    let value: Generations.Image = try jsonDecode(#"{"url":"http://foo.bar"}"#)
    XCTAssertNoDifference(
      Generations.Image.url(URL(string: "http://foo.bar")!),
      value
    )
  }

  func testImageDataBase64ToJSON() throws {
    let data = "ABC".data(using: .utf8)!
    let value = Generations.Image.data(data)
    XCTAssertNoDifference(
      #"{"b64_json":"QUJD"}"#,
      try jsonEncode(value, options: [.withoutEscapingSlashes]))
  }

  func testImageDataBase64FromJSON() throws {
    let data = "ABC".data(using: .utf8)!
    let value: Generations.Image = try jsonDecode(#"{"b64_json":"QUJD"}"#)
    XCTAssertNoDifference(
      Generations.Image.data(data),
      value
    )
  }

  func testImageToJSON() throws {
    let now = Date(timeIntervalSince1970: 1589478378)
    let value = Generations(
      created: now,
      images: [.url(URL(string: "http://foo.bar")!)]
    )

    XCTAssertNoDifference("""
      {"created":1589478378,"data":[{"url":"http://foo.bar"}]}
      """,
      try jsonEncode(value, options: [.withoutEscapingSlashes])
    )
  }
  
  func testImagesRequestFormatToJSON() throws {
    let value = Images.ResponseFormat.data
    XCTAssertEqual(#""b64_json""#, try jsonEncode(value))
  }
  
  func testImagesGenerationsToJSON() throws {
    let value = Images.Create(
      prompt: "foobar",
      n: 2,
      size: .of256x256,
      responseFormat: .data,
      user: "jblogs"
    )
    
    XCTAssertNoDifference(
      #"{"n":2,"prompt":"foobar","response_format":"b64_json","size":"256x256","user":"jblogs"}"#,
      try jsonEncode(value, options: [.withoutEscapingSlashes,.sortedKeys])
    )
  }

}
