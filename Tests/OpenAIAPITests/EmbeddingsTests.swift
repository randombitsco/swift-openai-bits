//
//  EmbeddingsTests.swift
//
//
//  Created by David Peterson on 19/7/2022.
//

import XCTest
import CustomDump
@testable import OpenAIAPI

final class EmbeddingsTests: XCTestCase {

  func testEmbeddingsStringRequestToJSON() throws {
    let value = Embeddings.Request(
      model: .text_davinci_002,
      input: "Input string."
    )
    XCTAssertNoDifference(
      #"{"model":"text-davinci-002","input":"Input string."}"#,
      try jsonEncode(value)
    )
  }

  func testEmbeddingsStringArrayRequestToJSON() throws {
    let value = Embeddings.Request(
      model: .text_davinci_002,
      input: .strings(["One", "Two"])
    )
    XCTAssertNoDifference(
      #"{"model":"text-davinci-002","input":["One","Two"]}"#,
      try jsonEncode(value)
    )
  }
  
  func testEmbeddingsTokenArrayRequestToJSON() throws {
    let value = Embeddings.Request(
      model: .text_davinci_002,
      input: .tokenArray([12,34,567])
    )
    XCTAssertNoDifference(
      #"{"model":"text-davinci-002","input":[12,34,567]}"#,
      try jsonEncode(value)
    )
  }

  func testEmbeddingsTokenArraysRequestToJSON() throws {
    let value = Embeddings.Request(
      model: .text_davinci_002,
      input: .tokenArrays([[12,34,567],[987,65,432,1]])
    )
    XCTAssertNoDifference(
      #"{"model":"text-davinci-002","input":[[12,34,567],[987,65,432,1]]}"#,
      try jsonEncode(value)
    )
  }
  
  func testJSONToEmbeddingsString() throws {
    let value: Embeddings.Request = try jsonDecode(#"{"model":"text-davinci-002","input":"Input string."}"#)
    XCTAssertNoDifference(
      .init(
        model: .text_davinci_002,
        input: "Input string."
      ),
      value
    )
  }
  
  func testJSONToEmbeddingsStringArray() throws {
    let value: Embeddings.Request = try jsonDecode(#"{"model":"text-davinci-002","input":["One","Two"]}"#)
    XCTAssertNoDifference(
      .init(
        model: .text_davinci_002,
        input: .strings(["One", "Two"])
      ),
      value
    )
  }

  func testJSONToEmbeddingsTokenArray() throws {
    let value: Embeddings.Request = try jsonDecode(#"{"model":"text-davinci-002","input":[12,34,567]}"#)
    XCTAssertNoDifference(
      .init(
        model: .text_davinci_002,
        input: .tokenArray([12,34,567])
      ),
      value
    )
  }
  
  func testJSONToEmbeddingsTokenArrays() throws {
    let value: Embeddings.Request = try jsonDecode(#"{"model":"text-davinci-002","input":[[12,34,567],[987,65,43]]}"#)
    XCTAssertNoDifference(
      .init(
        model: .text_davinci_002,
        input: .tokenArrays([[12,34,567],[987,65,43]])
      ),
      value
    )
  }
  
  func testEmbeddingsWithUserRequestToJSON() throws {
    let value = Embeddings.Request(
      model: .text_davinci_002,
      input: "Input string.",
      user: "foo"
    )
    XCTAssertNoDifference(
      #"{"model":"text-davinci-002","input":"Input string.","user":"foo"}"#,
      try jsonEncode(value)
    )
  }
  
  func testJSONToEmbeddingsWithUser() throws {
    let value: Embeddings.Request = try jsonDecode(#"{"model":"text-davinci-002","input":"Input string.","user":"foo"}"#)
    XCTAssertNoDifference(
      .init(
        model: .text_davinci_002,
        input: "Input string.",
        user: "foo"
      ),
      value
    )
  }
  

}
