import XCTest
import CustomDump
@testable import OpenAIBits

final class ImagesTests: XCTestCase {

    func testImageToJSON() throws {
      let value = Image.url("http://foo.bar")
      XCTAssertNoDifference(
        #"{"url":"http://foo.bar"}"#,
        try jsonEncode(value, options: [.withoutEscapingSlashes]))
    }
  
  func testImageFromJSON() throws {
    let value: Image = try jsonDecode(#"{"url":"http://foo.bar"}"#)
    XCTAssertNoDifference(
      Image.url("http://foo.bar"),
      value
    )
  }

}
